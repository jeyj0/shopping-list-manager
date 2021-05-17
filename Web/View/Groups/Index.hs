module Web.View.Groups.Index where
import Web.View.Prelude

data IndexView = IndexView { groups :: [Group] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href={GroupsAction}>Groups</a></li>
            </ol>
        </nav>
        <h1>Index <a href={pathTo NewGroupAction} class="btn btn-primary ml-4">+ New</a></h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Group</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach groups renderGroup}</tbody>
            </table>
        </div>
    |]


renderGroup group = [hsx|
    <tr>
        <td>{group}</td>
        <td><a href={ShowGroupAction (get #id group)}>Show</a></td>
        <td><a href={EditGroupAction (get #id group)} class="text-muted">Edit</a></td>
        <td><a href={DeleteGroupAction (get #id group)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
