module Web.Controller.Ingredients where

import Web.Controller.Prelude
import Web.View.Ingredients.Index
import Web.View.Ingredients.New
import Web.View.Ingredients.Edit
import Web.View.Ingredients.Show

instance Controller IngredientsController where
    action IngredientsAction = do
        ingredients <- query @Ingredient |> fetch
        render IndexView { .. }

    action NewIngredientAction { groupId } = do
        let ingredient = newRecord
              |> set #groupId groupId
        render NewView { .. }

    action ShowIngredientAction { ingredientId } = do
        ingredient <- fetch ingredientId
        let groupId = get #groupId ingredient

        availableShops <- query @Shop
          |> filterWhere (#groupId, groupId)
          |> fetch

        selectedShops <- sqlQuery (
          "SELECT s.* " <>
          "FROM shops AS s " <>
          "INNER JOIN packages AS p ON p.shop_id = s.id " <>
          "WHERE p.ingredient_id = ?"
          ) (Only ingredientId)

        render ShowView { .. }

    action EditIngredientAction { ingredientId } = do
        ingredient <- fetch ingredientId
        render EditView { .. }

    action UpdateIngredientAction { ingredientId } = do
        ingredient <- fetch ingredientId
        ingredient
            |> buildIngredient
            >>= ifValid \case
                Left ingredient -> render EditView { .. }
                Right ingredient -> do
                    ingredient <- ingredient |> updateRecord
                    setSuccessMessage "Ingredient updated"
                    redirectTo ShowGroupAction { groupId = get #groupId ingredient }

    action CreateIngredientAction = do
        let ingredient = newRecord @Ingredient
        ingredient
            |> buildIngredient
            >>= ifValid \case
                Left ingredient -> render NewView { .. } 
                Right ingredient -> do
                    ingredient <- ingredient |> createRecord
                    setSuccessMessage "Ingredient created"
                    redirectTo ShowGroupAction { groupId = get #groupId ingredient }

    action DeleteIngredientAction { ingredientId } = do
        ingredient <- fetch ingredientId
        deleteRecord ingredient
        setSuccessMessage "Ingredient deleted"
        redirectTo IngredientsAction

    action SetPackagesAction { ingredientId } = do
      ingredient <- fetch ingredientId
      possibleShops <- query @Shop
        |> filterWhere (#groupId, get #groupId ingredient)
        |> fetch
      let possibleShopIds :: [Id Shop] = map (get #id) possibleShops
          selectedShops :: [Id Shop] = paramList @(Id Shop) "shops"
          unselectedShops :: [Id Shop] = filter (\id -> not $ elem id selectedShops) possibleShopIds

      dbSelectedShops :: [Shop] <- sqlQuery ( 
        "SELECT s.* " <>
        "FROM shops AS s " <>
        "INNER JOIN packages AS p ON p.shop_id = s.id " <>
        "WHERE p.ingredient_id = ?"
        ) (Only ingredientId)

      let dbSelectedShopIds = map (get #id) dbSelectedShops
      let newSelections = filter (\shop -> not $ elem shop dbSelectedShopIds) selectedShops
          newUnselections = intersect dbSelectedShopIds unselectedShops

      createPackages ingredientId newSelections
      deletePackages ingredientId newUnselections

      redirectTo ShowGroupAction { groupId = get #groupId ingredient }

buildIngredient ingredient = ingredient
    |> fill @["groupId","name"]
    |> validateIsUnique #name

createPackages :: (?modelContext :: ModelContext) => Id Ingredient -> [Id Shop] -> IO [Package]
createPackages ingredientId shopIds = do
  let packageRecords = map packageRecord shopIds
  createMany packageRecords
  where
    packageRecord shopId = newRecord @Package
      |> set #ingredientId ingredientId
      |> set #shopId shopId

deletePackages :: (?modelContext :: ModelContext) => Id Ingredient -> [Id Shop] -> IO ()
deletePackages ingredientId shopIds = do
  packageRecords <- query @Package
    |> filterWhere (#ingredientId, ingredientId)
    |> filterWhereIn (#shopId, shopIds)
    |> fetch
  deleteRecords packageRecords
