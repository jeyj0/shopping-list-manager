module Web.Controller.Users where

import Web.Controller.Prelude
import Web.View.Users.New
import Web.View.Users.Dashboard

instance Controller UsersController where
    action NewUserAction = do
        let user = newRecord
        render NewView { .. }

    action CreateUserAction = do
        let user = newRecord @User
        user
            |> buildUser
            |> validateField #email isEmail
            |> validateField #passwordHash nonEmpty
            |> validateIsUnique #email
            >>= ifValid \case
                Left user -> render NewView { .. } 
                Right user -> do
                    hashed <- hashPassword (get #passwordHash user)
                    user <- user
                        |> set #passwordHash hashed
                        |> createRecord
                    setSuccessMessage "You have registered successfully"
                    redirectTo DashboardAction

    action DeleteUserAction { userId } = do
        user <- fetch userId
        deleteRecord user
        setSuccessMessage "User deleted"
        redirectTo StartPageAction

    action DashboardAction = do
      ensureIsUser

      user <- fetch currentUserId
      groups :: [Group] <- sqlQuery
        "SELECT g.* FROM groups as g INNER JOIN group_user_maps as m ON g.id = m.group_id WHERE m.user_id = ?"
        (Only currentUserId)
      render DashboardView { .. }

buildUser user = user
    |> fill @["email","passwordHash","failedLoginAttempts"]
