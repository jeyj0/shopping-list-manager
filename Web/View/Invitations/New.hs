module Web.View.Invitations.New where
import Web.View.Prelude

data NewView = NewView
  { invitation :: Invitation
  , users :: [User]
  , group :: Group
  }

instance View NewView where
  html NewView { .. } = [hsx|
    <nav>
      <a href={dashboardHref} class="mr-2">Dashboard</a>
      <a href={cancelHref}>Cancel</a>
    </nav>
    <h1>Invite user to {get #name group} group</h1>
    {renderForm users invitation}
  |]
    where
      dashboardHref = pathTo DashboardAction
      cancelHref = pathTo ShowGroupAction { groupId = get #id group }

renderForm :: [User] -> Invitation -> Html
renderForm users invitation = formFor invitation [hsx|
  {selectField #userId users}
  {(hiddenField #groupId)}
  {submitButton}
|]

instance CanSelect User where
  type SelectValue User = Id User
  selectValue = get #id
  selectLabel = get #email
