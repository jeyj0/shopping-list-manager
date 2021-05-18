module Web.View.EatingPlans.Edit where
import Web.View.Prelude

data EditView = EditView
  { eatingPlan :: EatingPlan
  , availableRecipes :: [Recipe]
  , recipes :: [Recipe]
  }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
          <a href={DashboardAction} class="mr-4">Dashboard</a>
          <a href={groupHref}>Back to Group</a>
        </nav>
        <h1>Edit EatingPlan</h1>
        {renderForm eatingPlan}
        {renderRecipesForm eatingPlan availableRecipes recipes}
    |]
      where
        groupHref = pathTo ShowGroupAction { groupId = get #groupId eatingPlan }

renderForm :: EatingPlan -> Html
renderForm eatingPlan = formFor eatingPlan [hsx|
  {(textField #name)}
  {submitButton}
|]

renderRecipesForm :: EatingPlan -> [Recipe] -> [Recipe] -> Html
renderRecipesForm eatingPlan availableRecipes recipes = [hsx|
  <h2>Recipes</h2>
  <ul>
    {forEach recipes renderRecipeItem}
  </ul>
  <form method="POST" action={formAction}>
    <select name="recipeId">
      {forEach availableRecipes renderRecipeOption}
    </select>
    <button class="btn btn-primary">Add Recipe</button>
    <p>Recipe not in list? <a href={createRecipeHref}>Create it</a></p>
  </form>
|]
  where
    eatingPlanId = get #id eatingPlan
    formAction = pathTo AddEatingPlanRecipeAction { .. }
    groupId = get #groupId eatingPlan
    createRecipeHref = pathTo NewRecipeAction { .. }
    
renderRecipeItem :: Recipe -> Html
renderRecipeItem recipe = [hsx|
  <li>{recipeName}</li>
|]
  where
    recipeName = get #name recipe

renderRecipeOption :: Recipe -> Html
renderRecipeOption recipe = [hsx|
  <option value={show $ get #id recipe}>{get #name recipe}</option>
|]
