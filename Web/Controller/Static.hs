module Web.Controller.Static where

import Web.Controller.Prelude
import Web.Controller.Sessions

instance Controller StaticController where
    action StartPageAction = case currentUserOrNothing of
      Just user -> redirectTo DashboardAction
      Nothing -> redirectTo NewSessionAction
