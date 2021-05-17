module Web.View.Users.Dashboard where

import Web.View.Prelude

data DashboardView = DashboardView
  { user :: User
  , groups :: [Group]
  }

instance View DashboardView where
  html DashboardView { .. } = [hsx|
    <div>
      Welcome to your personal shopping list manager, {get #email user}!
      <br>
      {renderGroups groups}
      <br>
      <a class="btn btn-primary" href={pathTo NewGroupAction}>Create New Group</a>
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
    {get #name group}
  </li>
|]
