module Web.View.Users.Dashboard where

import Web.View.Prelude
import GHC.Generics

data ViewInvitation = ViewInvitation
  { id :: Id Invitation
  , groupName :: Text
  , byUserEmail :: Text
  } deriving (Generic)
  
data DashboardView = DashboardView
  { user :: User
  , groups :: [Group]
  , invitations :: [ViewInvitation]
  }

instance View DashboardView where
  html DashboardView { .. } = [hsx|
    <div>
      Welcome to your personal shopping list manager, {get #email user}!
      <br>
      {forEach invitations renderInvitation}
      <br>
      {renderGroups groups}
      <br>
      <a class="btn btn-primary" href={pathTo NewGroupAction}>Create New Group</a>
    </div>
  |]

renderInvitation :: ViewInvitation -> Html
renderInvitation invitation = [hsx|
  <div class="alert alert-primary">
    {get #byUserEmail invitation} has invited you to join the {get #groupName invitation} group!
    <a class="btn btn-primary" href="">Accept</a>
    <a class="btn btn-secondary" href="">Decline</a>
  </div>
|]

renderGroups :: [Group] -> Html
renderGroups [] = [hsx|You are in no groups.|]
renderGroups groups =
  [hsx|
    You are in the groups:
    <ul>
      {forEach groups renderGroup}
    </ul>
  |]

renderGroup :: Group -> Html
renderGroup group = [hsx|
  <li>
    <a href={href}>{get #name group}</a>
  </li>
|]
  where
    groupId = get #id group
    href = pathTo ShowGroupAction { .. }
