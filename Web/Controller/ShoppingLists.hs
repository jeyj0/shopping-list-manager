module Web.Controller.ShoppingLists where

import Web.Controller.Prelude
import Web.View.ShoppingLists.Index
import Web.View.ShoppingLists.New
import Web.View.ShoppingLists.Edit
import Web.View.ShoppingLists.Show

shoppingListPlansBaseSQL joinType =
  "SELECT p.* " <>
  "FROM eating_plans as p " <>
  joinType <> " JOIN shopping_list_eating_plans AS sp ON sp.eating_plan_id = p.id "

shoppingListPlans :: (?modelContext :: ModelContext) => Id ShoppingList -> IO [EatingPlan]
shoppingListPlans listId = do
  let sql = shoppingListPlansBaseSQL "INNER" <> "WHERE sp.shopping_list_id = ?"
  sqlQuery sql $ Only listId

plansNotInList :: (?modelContext :: ModelContext) => Id ShoppingList -> IO [EatingPlan]
plansNotInList listId = do
  let sql = shoppingListPlansBaseSQL "LEFT" <>
        "WHERE (sp.shopping_list_id IS NULL OR sp.shopping_list_id <> ?) " <>
        "AND p.group_id = (SELECT group_id FROM shopping_lists WHERE id = ?)"
  sqlQuery sql $ (listId, listId)

findExtraItems :: (?modelContext::ModelContext) => Id ShoppingList -> IO [Ingredient]
findExtraItems shoppingListId = do
  let sql = "SELECT i.* " <>
            "FROM ingredients AS i " <>
            "INNER JOIN extra_items AS ei ON ei.ingredient_id = i.id " <>
            "WHERE ei.shopping_list_id = ?"
  sqlQuery sql $ Only shoppingListId
  
findRecipeItems :: (?modelContext :: ModelContext) => Id ShoppingList -> IO [Ingredient]
findRecipeItems shoppingListId = do
  let sql = "SELECT i.* " <>
            "FROM ingredients AS i " <>
            "INNER JOIN recipe_ingredients AS ri ON ri.ingredient_id = i.id " <>
            "INNER JOIN eating_plan_recipes AS pr ON pr.recipe_id = ri.recipe_id " <>
            "INNER JOIN shopping_list_eating_plans AS lp ON lp.eating_plan_id = pr.eating_plan_id " <>
            "WHERE lp.shopping_list_id = ?"
  sqlQuery sql $ Only shoppingListId

instance Controller ShoppingListsController where
    action ShoppingListsAction = do
        shoppingLists <- query @ShoppingList |> fetch
        render IndexView { .. }

    action NewShoppingListAction { groupId } = do
        let shoppingList = newRecord
              |> set #groupId groupId
        render NewView { .. }

    action ShowShoppingListAction { shoppingListId } = do
        shoppingList <- fetch shoppingListId
        extraItems <- findExtraItems shoppingListId
        recipeItems <- findRecipeItems shoppingListId
        let items = extraItems ++ recipeItems
        render ShowView { .. }

    action EditShoppingListAction { shoppingListId } = do
        shoppingList <- fetch shoppingListId
        availablePlans <- plansNotInList shoppingListId
        plans <- shoppingListPlans shoppingListId
        extraItems <- findExtraItems shoppingListId
        availableExtraItems <- query @Ingredient
          |> findManyBy #groupId (get #groupId shoppingList)
        render EditView { .. }

    action UpdateShoppingListAction { shoppingListId } = do
        shoppingList <- fetch shoppingListId
        shoppingList
            |> buildShoppingList
            |> ifValid \case
                Left shoppingList -> do
                  availablePlans <- plansNotInList shoppingListId
                  plans <- shoppingListPlans shoppingListId
                  extraItems <- findExtraItems shoppingListId
                  availableExtraItems <- query @Ingredient
                    |> findManyBy #groupId (get #groupId shoppingList)
                  render EditView { .. }
                Right shoppingList -> do
                    shoppingList <- shoppingList |> updateRecord
                    setSuccessMessage "ShoppingList updated"
                    redirectTo EditShoppingListAction { .. }

    action AddShoppingListEatingPlanAction { shoppingListId } = do
      let eatingPlanId = param @(Id EatingPlan) "eatingPlanId"
      newRecord @ShoppingListEatingPlan
        |> set #eatingPlanId eatingPlanId
        |> set #shoppingListId shoppingListId
        |> createRecord
      redirectTo EditShoppingListAction { .. }

    action AddExtraItemAction { shoppingListId } = do
      let ingredientId = param @(Id Ingredient) "ingredientId"
      newRecord @ExtraItem
        |> set #shoppingListId shoppingListId
        |> set #ingredientId ingredientId
        |> createRecord
      redirectTo EditShoppingListAction { .. }

    action CreateShoppingListAction = do
        let shoppingList = newRecord @ShoppingList
        shoppingList
            |> buildShoppingList
            |> ifValid \case
                Left shoppingList -> render NewView { .. } 
                Right shoppingList -> do
                    shoppingList <- shoppingList |> createRecord
                    setSuccessMessage "ShoppingList created"
                    redirectTo ShowGroupAction { groupId = get #groupId shoppingList }

    action DeleteShoppingListAction { shoppingListId } = do
        shoppingList <- fetch shoppingListId
        deleteRecord shoppingList
        setSuccessMessage "ShoppingList deleted"
        redirectTo ShoppingListsAction

buildShoppingList shoppingList = shoppingList
    |> fill @["name","groupId"]
