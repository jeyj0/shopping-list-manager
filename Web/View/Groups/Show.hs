module Web.View.Groups.Show where
import Web.View.Prelude

import Web.Controller.Static

data ShowView = ShowView
  { group :: Include' ["recipes", "ingredients"] Group
  , users :: [User]
  }

instance View ShowView where
  html ShowView { .. } = [hsx|
    <nav>
      <ol class="breadcrumb">
        <li class="breadcrumb-item"><a href={pathTo DashboardAction}>Dashboard</a></li>
      </ol>
    </nav>
    <h1>{get #name group}</h1>
    <h2>Members</h2>
    <ul>
      {forEach users renderUser}
    </ul>
    <a class="btn btn-primary" href={inviteHref}>Invite more</a>
    <h2>Recipes</h2>
    <ul>
      {forEach (get #recipes group) renderRecipe}
    </ul>
    <a class="btn btn-primary" href={newRecipeHref}>Create new Recipe</a>
    <h2>Ingredients</h2>
    <ul>
      {forEach (get #ingredients group) renderIngredient}
    </ul>
    <a class="btn btn-primary" href={newIngredientHref}>Add Ingredient</a>
  |]
    where
      inviteHref = pathTo NewInvitationAction { groupId = get #id group }
      newRecipeHref = pathTo NewRecipeAction { groupId = get #id group }
      newIngredientHref = pathTo NewIngredientAction { groupId = get #id group }

renderUser :: User -> Html
renderUser user = [hsx|
  <li>{get #email user}</li>
|]

renderIngredient :: Ingredient -> Html
renderIngredient ingredient = [hsx|
  <li>{get #name ingredient}</li>
|]

renderRecipe :: Recipe -> Html
renderRecipe recipe = [hsx|
  <li><a href={editRecipeHref}>{get #name recipe}</a></li>
|]
  where
    editRecipeHref = pathTo EditRecipeAction { recipeId = get #id recipe }
