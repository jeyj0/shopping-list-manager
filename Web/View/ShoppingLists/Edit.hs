module Web.View.ShoppingLists.Edit where
import Web.View.Prelude

data EditView = EditView
  { shoppingList :: ShoppingList
  , availablePlans :: [EatingPlan]
  , plans :: [EatingPlan]
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
    |]
      where
        groupHref = pathTo ShowGroupAction { groupId = get #groupId shoppingList }

renderForm :: ShoppingList -> Html
renderForm shoppingList = formFor shoppingList [hsx|
    {(textField #name)}
    {(hiddenField #groupId)}
    {submitButton}
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
