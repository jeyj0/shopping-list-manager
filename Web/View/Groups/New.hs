module Web.View.Groups.New where
import Web.View.Prelude

data NewView = NewView { group :: Group }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={GroupsAction}>Groups</a></li>
                <li class="breadcrumb-item active">New Group</li>
            </ol>
        </nav>
        <h1>New Group</h1>
        {renderForm group}
    |]

renderForm :: Group -> Html
renderForm group = formFor group [hsx|
    {(textField #name)}
    {submitButton}
|]
