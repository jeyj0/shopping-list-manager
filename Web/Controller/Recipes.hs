module Web.Controller.Recipes where

import Web.Controller.Prelude
import Web.View.Recipes.Index
import Web.View.Recipes.New
import Web.View.Recipes.Edit
import Web.View.Recipes.Show

instance Controller RecipesController where
    action RecipesAction = do
        recipes <- query @Recipe |> fetch
        render IndexView { .. }

    action NewRecipeAction { groupId } = do
        let recipe = newRecord
              |> set #groupId groupId
        render NewView { .. }

    action ShowRecipeAction { recipeId } = do
        recipe <- fetch recipeId
        render ShowView { .. }

    action EditRecipeAction { recipeId } = do
        recipe <- fetch recipeId
        group <- fetch $ get #groupId recipe
        render EditView { .. }

    action UpdateRecipeAction { recipeId } = do
        recipe <- fetch recipeId
        recipe
            |> buildRecipe
            |> ifValid \case
                Left recipe -> do
                  group <- fetch $ get #groupId recipe
                  render EditView { .. }
                Right recipe -> do
                    recipe <- recipe |> updateRecord
                    setSuccessMessage "Recipe updated"
                    redirectTo ShowGroupAction { groupId = get #groupId recipe }

    action CreateRecipeAction = do
        let recipe = newRecord @Recipe
        recipe
            |> buildRecipe
            |> ifValid \case
                Left recipe -> render NewView { .. } 
                Right recipe -> do
                    recipe <- recipe |> createRecord
                    setSuccessMessage "Recipe created"
                    redirectTo EditRecipeAction { recipeId = get #id recipe }

    action DeleteRecipeAction { recipeId } = do
        recipe <- fetch recipeId
        deleteRecord recipe
        setSuccessMessage "Recipe deleted"
        redirectTo RecipesAction

buildRecipe recipe = recipe
    |> fill @["groupId","name"]
