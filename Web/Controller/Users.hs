module Web.Controller.Users where

import Web.Controller.Prelude
import Web.View.Users.Index
import Web.View.Users.New
import Web.View.Users.Edit
import Web.View.Users.Show
import Web.View.Users.Dashboard

instance Controller UsersController where
    action UsersAction = do
        users <- query @User |> fetch
        render IndexView { .. }

    action NewUserAction = do
        let user = newRecord
        render NewView { .. }

    action ShowUserAction { userId } = do
        user <- fetch userId
        render ShowView { .. }

    action EditUserAction { userId } = do
        user <- fetch userId
        render EditView { .. }

    action UpdateUserAction { userId } = do
        user <- fetch userId
        user
            |> buildUser
            |> ifValid \case
                Left user -> render EditView { .. }
                Right user -> do
                    user <- user |> updateRecord
                    setSuccessMessage "User updated"
                    redirectTo EditUserAction { .. }

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
                    let userId = get #id user
                    redirectTo DashboardAction { .. }

    action DeleteUserAction { userId } = do
        user <- fetch userId
        deleteRecord user
        setSuccessMessage "User deleted"
        redirectTo UsersAction

    action DashboardAction { userId } = do
      ensureIsUser

      accessDeniedUnless $ userId == currentUserId
      
      user <- fetch userId
        -- >>= fetchRelated #userGroupMaps
        -- >>= fetchRelated #groups
      groups :: [Group] <- sqlQuery "SELECT * FROM groups as g INNER JOIN group_user_maps as m ON g.id = m.group_id WHERE m.user_id = ?" (Only userId)
      render DashboardView { .. }

buildUser user = user
    |> fill @["email","passwordHash","failedLoginAttempts"]
