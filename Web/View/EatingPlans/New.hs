module Web.View.EatingPlans.New where
import Web.View.Prelude

data NewView = NewView { eatingPlan :: EatingPlan }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
          <a href={DashboardAction} class="mr-4">Dashboard</a>
          <a href={groupHref}>Back to Group</a>
        </nav>
        <h1>New EatingPlan</h1>
        {renderForm eatingPlan}
    |]
      where
        groupHref = pathTo ShowGroupAction { groupId = get #groupId eatingPlan }

renderForm :: EatingPlan -> Html
renderForm eatingPlan = formFor eatingPlan [hsx|
  {(hiddenField #groupId)}
  {(textField #name)}
  {submitButton}
|]
