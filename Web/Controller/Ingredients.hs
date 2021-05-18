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

buildIngredient ingredient = ingredient
    |> fill @["groupId","name"]
    |> validateIsUnique #name
