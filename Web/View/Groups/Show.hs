module Web.View.Groups.Show where
import Web.View.Prelude

import Web.Controller.Static

data ShowView = ShowView
  { group :: Include' ["recipes", "ingredients", "eatingPlans", "shoppingLists"] Group
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
    <h2>Eating Plans</h2>
    <ul>
      {forEach (get #eatingPlans group) renderPlan}
    </ul>
    <a class="btn btn-primary" href={newPlanHref}>New Plan</a>
    <h2>Shopping Lists</h2>
    <ul>
      {forEach (get #shoppingLists group) renderList}
    </ul>
    <a class="btn btn-primary" href={newShoppingListHref}>New Shopping List</a>
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
      groupId = get #id group
      newPlanHref = pathTo NewEatingPlanAction { .. }
      inviteHref = pathTo NewInvitationAction { .. }
      newRecipeHref = pathTo NewRecipeAction { .. }
      newIngredientHref = pathTo NewIngredientAction { .. }
      newShoppingListHref = pathTo NewShoppingListAction { .. }

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

renderPlan :: EatingPlan -> Html
renderPlan plan = [hsx|
  <li><a href={editPlanHref}>{displayName}</a></li>
|]
  where
    editPlanHref = pathTo EditEatingPlanAction { eatingPlanId = get #id plan }
    displayName = get #name plan

renderList :: ShoppingList -> Html
renderList list = [hsx|
  <li><a href={editListHref}>{get #name list}</a></li>
|]
  where
    editListHref = pathTo EditShoppingListAction { shoppingListId = get #id list }
