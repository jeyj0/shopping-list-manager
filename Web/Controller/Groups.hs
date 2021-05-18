module Web.Controller.Groups where

import Web.Controller.Prelude
import Web.View.Groups.New
import Web.View.Groups.Show
import Web.ControllerFunctions

instance Controller GroupsController where
    beforeAction = ensureIsUser
  
    action NewGroupAction = do
        ensureIsUser
        let group = newRecord
        render NewView { .. }

    action ShowGroupAction { groupId } = do
        group <- fetch groupId >>= fetchRelated #ingredients
        user <- fetch currentUserId
        users :: [User] <- groupMembers groupId
        render ShowView { .. }

    action CreateGroupAction = do
        let group = newRecord @Group

        group
            |> buildGroup
            |> ifValid \case
                Left group -> render NewView { .. } 
                Right group -> do
                    group <- group |> createRecord
                    let groupId = get #id group

                    groupUserMap <- newRecord @GroupUserMap
                      |> set #userId currentUserId
                      |> set #groupId groupId
                      |> createRecord
    
                    setSuccessMessage "Group created"
                    redirectTo ShowGroupAction { .. }

    action DeleteGroupAction { groupId } = do
        group <- fetch groupId
        deleteRecord group
        setSuccessMessage "Group deleted"
        redirectTo DashboardAction

buildGroup group = group
    |> fill @'["name"]
