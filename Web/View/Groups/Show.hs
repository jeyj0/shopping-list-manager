module Web.View.Groups.Show where
import Web.View.Prelude

import Web.Controller.Static

data ShowView = ShowView
  { group :: Group
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
  |]

renderUser :: User -> Html
renderUser user = [hsx|
  <li>{get #email user}</li>
|]
