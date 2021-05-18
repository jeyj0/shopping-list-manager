module Web.View.EatingPlans.Edit where
import Web.View.Prelude

data EditView = EditView { eatingPlan :: EatingPlan }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
          <a href={DashboardAction} class="mr-4">Dashboard</a>
          <a href={groupHref}>Back to Group</a>
        </nav>
        <h1>Edit EatingPlan</h1>
        {renderForm eatingPlan}
    |]
      where
        groupHref = pathTo ShowGroupAction { groupId = get #groupId eatingPlan }

renderForm :: EatingPlan -> Html
renderForm eatingPlan = formFor eatingPlan [hsx|

    {submitButton}
|]
