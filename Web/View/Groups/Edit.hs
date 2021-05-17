module Web.View.Groups.Edit where
import Web.View.Prelude

data EditView = EditView { group :: Group }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={GroupsAction}>Groups</a></li>
                <li class="breadcrumb-item active">Edit Group</li>
            </ol>
        </nav>
        <h1>Edit Group</h1>
        {renderForm group}
    |]

renderForm :: Group -> Html
renderForm group = formFor group [hsx|
    {(textField #name)}
    {submitButton}
|]
