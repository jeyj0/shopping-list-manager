module Web.View.Groups.New where

import Web.View.Prelude

data NewView = NewView { group :: Group }

instance View NewView where
  html NewView { .. } = [hsx|
    <nav>
      <a href={pathTo DashboardAction}>Dashboard</a>
    </nav>
    <h1>New Group</h1>
    {renderForm group}
  |]

renderForm :: Group -> Html
renderForm group = formFor group [hsx|
    {(textField #name)}
    {submitButton}
|]
