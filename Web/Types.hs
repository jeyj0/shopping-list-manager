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
    = DashboardAction
    | NewUserAction
    | CreateUserAction
    | DeleteUserAction { userId :: !(Id User) }
    deriving (Eq, Show, Data)

data GroupsController
    = GroupsAction
    | NewGroupAction
    | ShowGroupAction { groupId :: !(Id Group) }
    | CreateGroupAction
    | DeleteGroupAction { groupId :: !(Id Group) }
    deriving (Eq, Show, Data)
