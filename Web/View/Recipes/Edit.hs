module Web.View.Recipes.Edit where
import Web.View.Prelude

data EditView = EditView
  { recipe :: Recipe
  , ingredients :: [Ingredient]
  , availableIngredients :: [Ingredient]
  , group :: Group
  }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
          <a href={DashboardAction} class="mr-4">Dashboard</a>
          <a href={showGroupHref}>{get #name group}</a>
        </nav>
        <h1>Edit Recipe</h1>
        {renderForm recipe}
        {renderIngredientForm recipe availableIngredients ingredients}
    |]
      where
        showGroupHref = pathTo ShowGroupAction { groupId = get #id group }

renderForm :: Recipe -> Html
renderForm recipe = [hsx|
  <form method="POST" action={formAction} id="" class="new-form">
    <div class="form-group" id="form-group-recipe_name">
      <label for="recipe_name">Name</label>
      <input type="text" name="name" id="recipe_name" class="form-control" value={get #name recipe} />
    </div>
    <button class="btn btn-primary">Save Recipe</button>
  </form>
|]
  where
    formAction = pathTo UpdateRecipeAction { recipeId = get #id recipe }


renderIngredientForm :: Recipe -> [Ingredient] -> [Ingredient] -> Html
renderIngredientForm recipe availableIngredients ingredients = [hsx|
  <h2>Ingredients</h2>
  <ul>
    {forEach ingredients renderIngredientItem}
  </ul>
  <form method="POST" action={formAction}>
    {renderIngredientOptions availableIngredients}
    <p>Ingredient not in list? <a href={createIngredientHref}>Create it</a></p>
  </form>
|]
  where
    formAction = pathTo AddIngredientAction { .. }
    recipeId = get #id recipe
    createIngredientHref = pathTo NewIngredientAction { groupId = get #groupId recipe }

renderIngredientItem :: Ingredient -> Html
renderIngredientItem ingredient = [hsx|
  <li>{ingredientName}</li>
|]
  where
    ingredientName = get #name ingredient

renderIngredientOptions :: [Ingredient] -> Html
renderIngredientOptions [] = [hsx|All existing ingredients have been added to this recipe already.|]
renderIngredientOptions ingredients = [hsx|
  <select name="ingredientId">
    {forEach ingredients renderIngredientOption}
  </select>
  <button class="btn btn-primary">Add Ingredient</button>
|]
  where
    renderIngredientOption :: Ingredient -> Html
    renderIngredientOption ingredient = [hsx|
      <option value={ingredientId}>{ingredientName}</option>
    |]
      where
        ingredientId = show $ get #id ingredient
        ingredientName = get #name ingredient
