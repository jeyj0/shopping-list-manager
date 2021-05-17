module Web.View.Invitations.Index where
import Web.View.Prelude

data IndexView = IndexView { invitations :: [Invitation] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href={InvitationsAction}>Invitations</a></li>
            </ol>
        </nav>
        <h1>Index <a href={pathTo NewInvitationAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Invitation</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach invitations renderInvitation}</tbody>
            </table>
        </div>
    |]


renderInvitation invitation = [hsx|
    <tr>
        <td>{invitation}</td>
        <td><a href={ShowInvitationAction (get #id invitation)}>Show</a></td>
        <td><a href={DeleteInvitationAction (get #id invitation)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
