module Web.View.Groups.Show where
import Web.View.Prelude

data ShowView = ShowView { group :: Group }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={GroupsAction}>Groups</a></li>
                <li class="breadcrumb-item active">Show Group</li>
            </ol>
        </nav>
        <h1>Show Group</h1>
        <p>{group}</p>
    |]
