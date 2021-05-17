module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types
import IHP.LoginSupport.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController
  = StartPageAction
  deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
  newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User

data SessionsController
  = NewSessionAction
  | CreateSessionAction
  | DeleteSessionAction
  deriving (Eq, Show, Data)

data UsersController
    = UsersAction
    | DashboardAction
    | NewUserAction
    | ShowUserAction { userId :: !(Id User) }
    | CreateUserAction
    | EditUserAction { userId :: !(Id User) }
    | UpdateUserAction { userId :: !(Id User) }
    | DeleteUserAction { userId :: !(Id User) }
    deriving (Eq, Show, Data)

data GroupsController
    = GroupsAction
    | NewGroupAction
    | ShowGroupAction { groupId :: !(Id Group) }
    | CreateGroupAction
    | EditGroupAction { groupId :: !(Id Group) }
    | UpdateGroupAction { groupId :: !(Id Group) }
    | DeleteGroupAction { groupId :: !(Id Group) }
    deriving (Eq, Show, Data)
