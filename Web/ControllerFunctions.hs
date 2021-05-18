module Web.ControllerFunctions where

import IHP.ControllerPrelude
import Web.Controller.Prelude

groupMembers :: (?modelContext :: ModelContext) => Id Group -> IO [User]
groupMembers groupId =
  sqlQuery "SELECT u.* FROM users as u INNER JOIN group_user_maps as m ON m.user_id = u.id WHERE m.group_id = ?" (Only groupId)
