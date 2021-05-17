module Web.Controller.Groups where

import Web.Controller.Prelude
import Web.View.Groups.Index
import Web.View.Groups.New
import Web.View.Groups.Edit
import Web.View.Groups.Show

instance Controller GroupsController where
    beforeAction = ensureIsUser
  
    action GroupsAction = do
        groups <- query @Group |> fetch
        render IndexView { .. }

    action NewGroupAction = do
        ensureIsUser
        let group = newRecord
        render NewView { .. }

    action ShowGroupAction { groupId } = do
        group <- fetch groupId
        render ShowView { .. }

    action EditGroupAction { groupId } = do
        group <- fetch groupId
        render EditView { .. }

    action UpdateGroupAction { groupId } = do
        group <- fetch groupId
        group
            |> buildGroup
            |> ifValid \case
                Left group -> render EditView { .. }
                Right group -> do
                    group <- group |> updateRecord
                    setSuccessMessage "Group updated"
                    redirectTo EditGroupAction { .. }

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
        redirectTo GroupsAction

buildGroup group = group
    |> fill @'["name"]
