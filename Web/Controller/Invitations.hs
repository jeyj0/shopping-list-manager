module Web.Controller.Invitations where

import Web.Controller.Prelude
import Web.View.Invitations.Index
import Web.View.Invitations.New
import Web.View.Invitations.Show
import Web.ControllerFunctions

instance Controller InvitationsController where
  beforeAction = ensureIsUser

  action InvitationsAction = do
      invitations <- query @Invitation |> fetch
      render IndexView { .. }

  action NewInvitationAction { groupId } = do
      let invitation = newRecord
            |> set #groupId groupId
      usersInGroup <- groupMembers groupId
      users <- query @User
        |> filterWhereNotIn (#id, currentUserId:(map (get #id) usersInGroup))
        |> fetch
      group <- fetch groupId
      render NewView { .. }

  action ShowInvitationAction { invitationId } = do
      invitation <- fetch invitationId
      render ShowView { .. }

  action CreateInvitationAction = do
      let invitation = newRecord @Invitation
      invitation
          |> buildInvitation
          |> set #byUserId currentUserId
          |> ifValid \case
              Left invitation -> do
                let groupId = get #groupId invitation
                usersInGroup <- groupMembers groupId
                users <- query @User
                  |> filterWhereNotIn (#id, currentUserId:(map (get #id) usersInGroup))
                  |> fetch
                group <- fetch groupId
                render NewView { .. } 
              Right invitation -> do
                  invitation <- invitation |> createRecord
                  setSuccessMessage "Invitation created"
                  redirectTo DashboardAction

  action AcceptInvitationAction { invitationId } = do
    invitation <- fetch invitationId
    let userId = get #userId invitation
        groupId = get #groupId invitation

    accessDeniedUnless $ userId == currentUserId

    withTransaction do
      let groupUserMap = newRecord @GroupUserMap
      groupUserMap
        |> set #userId userId
        |> set #groupId groupId
        |> createRecord
      deleteRecordById @Invitation $ get #id invitation

    redirectTo DashboardAction

  action DeclineInvitationAction { invitationId } = do
    deleteRecordById @Invitation invitationId
    redirectTo DashboardAction

  action DeleteInvitationAction { invitationId } = do
      invitation <- fetch invitationId
      deleteRecord invitation
      setSuccessMessage "Invitation deleted"
      redirectTo InvitationsAction

buildInvitation invitation = invitation
    |> fill @["userId","groupId","byUserId"]
