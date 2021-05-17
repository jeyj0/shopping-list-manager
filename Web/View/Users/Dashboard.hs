module Web.View.Users.Dashboard where

import Web.View.Prelude

data DashboardView = DashboardView
  { user :: User
  }

instance View DashboardView where
  html DashboardView { .. } = [hsx|
    <div>
      Welcome to your personal shopping list manager, {get #email user}!
    </div>
  |]
