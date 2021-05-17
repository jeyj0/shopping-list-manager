module Web.View.Invitations.New where
import Web.View.Prelude

data NewView = NewView { invitation :: Invitation }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={InvitationsAction}>Invitations</a></li>
                <li class="breadcrumb-item active">New Invitation</li>
            </ol>
        </nav>
        <h1>New Invitation</h1>
        {renderForm invitation}
    |]

renderForm :: Invitation -> Html
renderForm invitation = formFor invitation [hsx|
    {(textField #userId)}
    {(textField #groupId)}
    {(textField #byUserId)}
    {submitButton}
|]
