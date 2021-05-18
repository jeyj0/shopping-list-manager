module Web.Controller.Users where

import Database.PostgreSQL.Simple.FromRow
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

      invitations :: [ViewInvitation] <- sqlQuery (
        "SELECT i.id, g.name AS group_name, u.email AS by_user_email " <>
        "FROM invitations AS i " <>
        "INNER JOIN groups AS g ON g.id = i.group_id " <>
        "INNER JOIN users AS u ON i.by_user_id = u.id " <>
        "WHERE i.user_id = ?"
        ) (Only currentUserId)

      render DashboardView { .. }

buildUser user = user
    |> fill @["email","passwordHash","failedLoginAttempts"]

instance FromRow ViewInvitation where
  fromRow = do
    id <- field
    groupName <- field
    byUserEmail <- field
    let viewInvitation = ViewInvitation { .. }
    pure viewInvitation
