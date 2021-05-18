module Web.Controller.Recipes where

import Web.Controller.Prelude
import Web.View.Recipes.Index
import Web.View.Recipes.New
import Web.View.Recipes.Edit
import Web.View.Recipes.Show

recipeIngredientsBaseSQL joinType =
  "SELECT i.* " <>
  "FROM ingredients as i " <>
  joinType <> " JOIN recipe_ingredients AS ri ON ri.ingredient_id = i.id "

recipesIngredients :: (?modelContext :: ModelContext) => Id Recipe -> IO [Ingredient]
recipesIngredients recipeId = do
  let sql = recipeIngredientsBaseSQL "INNER" <> "WHERE ri.recipe_id = ?"
  sqlQuery sql $ Only recipeId

ingredientsNotInRecipe :: (?modelContext :: ModelContext) => Id Recipe -> IO [Ingredient]
ingredientsNotInRecipe recipeId = do
  let sql = recipeIngredientsBaseSQL "LEFT" <>
        "WHERE (ri.recipe_id IS NULL OR ri.recipe_id <> ?) " <>
        "AND i.group_id = (SELECT group_id FROM recipes WHERE id = ?)"
  sqlQuery sql $ (recipeId, recipeId)

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
        let recipeId = get #id recipe
        availableIngredients <- ingredientsNotInRecipe recipeId
        ingredients <- recipesIngredients recipeId
        render EditView { .. }

    action UpdateRecipeAction { recipeId } = do
        recipe <- fetch recipeId
        recipe
            |> buildRecipe
            |> ifValid \case
                Left recipe -> do
                  group <- fetch $ get #groupId recipe
                  availableIngredients <- ingredientsNotInRecipe recipeId
                  ingredients <- recipesIngredients recipeId
                  render EditView { .. }
                Right recipe -> do
                    recipe <- recipe |> updateRecord
                    setSuccessMessage "Recipe updated"
                    redirectTo ShowGroupAction { groupId = get #groupId recipe }

    action AddIngredientAction { recipeId } = do
      let ingredientId = param @(Id Ingredient) "ingredientId"
      newRecord @RecipeIngredient
            |> set #ingredientId ingredientId
            |> set #recipeId recipeId
            |> createRecord
      redirectTo EditRecipeAction { .. }

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
