module Web.Controller.Invitations where

import Web.Controller.Prelude
import Web.View.Invitations.Index
import Web.View.Invitations.New
import Web.View.Invitations.Show

instance Controller InvitationsController where
    action InvitationsAction = do
        invitations <- query @Invitation |> fetch
        render IndexView { .. }

    action NewInvitationAction = do
        let invitation = newRecord
        render NewView { .. }

    action ShowInvitationAction { invitationId } = do
        invitation <- fetch invitationId
        render ShowView { .. }

    action CreateInvitationAction = do
        let invitation = newRecord @Invitation
        invitation
            |> buildInvitation
            |> ifValid \case
                Left invitation -> render NewView { .. } 
                Right invitation -> do
                    invitation <- invitation |> createRecord
                    setSuccessMessage "Invitation created"
                    redirectTo InvitationsAction

    action DeleteInvitationAction { invitationId } = do
        invitation <- fetch invitationId
        deleteRecord invitation
        setSuccessMessage "Invitation deleted"
        redirectTo InvitationsAction

buildInvitation invitation = invitation
    |> fill @["userId","groupId","byUserId"]
