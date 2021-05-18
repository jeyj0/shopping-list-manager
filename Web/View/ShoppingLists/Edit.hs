module Web.View.ShoppingLists.Edit where
import Web.View.Prelude

data EditView = EditView
  { shoppingList :: ShoppingList
  , availablePlans :: [EatingPlan]
  , plans :: [EatingPlan]
  , availableExtraItems :: [Ingredient]
  , extraItems :: [Ingredient]
  }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
          <a href={DashboardAction} class="mr-4">Dashboard</a>
          <a href={groupHref}>Back to Group</a>
        </nav>
        <h1>Edit ShoppingList</h1>
        {renderForm shoppingList}
        {renderPlansForm shoppingList availablePlans plans}
        {renderExtraItemsForm shoppingList availableExtraItems extraItems}
    |]
      where
        groupHref = pathTo ShowGroupAction { groupId = get #groupId shoppingList }

renderForm :: ShoppingList -> Html
renderForm shoppingList = formFor shoppingList [hsx|
    {(textField #name)}
    {(hiddenField #groupId)}
    {submitButton}
|]

renderExtraItemsForm :: ShoppingList -> [Ingredient] -> [Ingredient] -> Html
renderExtraItemsForm shoppingList availableExtraItems extraItems = [hsx|
  <h2>Extra Items</h2>
  <ul>
    {forEach extraItems renderExtraItemItem}
  </ul>
  <form method="POST" action={formAction}>
    <select name="ingredientId">
      {forEach availableExtraItems renderExtraItemOption}
    </select>
    <button class="btn btn-primary" type="submit">Add Extra Item</button>
    <p>Item not in list? <a href={createIngredientHref}>Create it</a></p>
  </form>
|]
  where
    shoppingListId = get #id shoppingList
    formAction = pathTo AddExtraItemAction { .. }
    groupId = get #groupId shoppingList
    createIngredientHref = pathTo NewIngredientAction { .. }

renderExtraItemItem :: Ingredient -> Html
renderExtraItemItem item = [hsx|
  <li>{get #name item}</li>
|]
  
renderExtraItemOption :: Ingredient -> Html
renderExtraItemOption item = [hsx|
  <option value={show $ get #id item}>{get #name item}</option>
|]
  
renderPlansForm :: ShoppingList -> [EatingPlan] -> [EatingPlan] -> Html
renderPlansForm shoppingList availablePlans plans = [hsx|
  <h2>Eating Plans</h2>
  <ul>
    {forEach plans renderPlanItem}
  </ul>
  <form method="POST" action={formAction}>
    {renderPlanOptions availablePlans}
    <p>Plan not in list? <a href={createPlanHref}>Create it</a></p>
  </form>
|]
  where
    shoppingListId = get #id shoppingList
    formAction = pathTo AddShoppingListEatingPlanAction { .. }
    groupId = get #groupId shoppingList
    createPlanHref = pathTo NewEatingPlanAction { .. }

renderPlanItem :: EatingPlan -> Html
renderPlanItem plan = [hsx|
  <li>{planName}</li>
|]
  where
    planName = get #name plan

renderPlanOptions :: [EatingPlan] -> Html
renderPlanOptions [] = [hsx|All existing plans have been added to this list.|]
renderPlanOptions plans = [hsx|
  <select name="eatingPlanId">
    {forEach plans renderPlanOption}
  </select>
  <button class="btn btn-primary">Add Plan</button>
|]
  
renderPlanOption :: EatingPlan -> Html
renderPlanOption plan = [hsx|
  <option value={show $ get #id plan}>{get #name plan}</option>
|]
