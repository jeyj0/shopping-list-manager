module Web.View.Invitations.Show where
import Web.View.Prelude

data ShowView = ShowView { invitation :: Invitation }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={InvitationsAction}>Invitations</a></li>
                <li class="breadcrumb-item active">Show Invitation</li>
            </ol>
        </nav>
        <h1>Show Invitation</h1>
        <p>{invitation}</p>
    |]
