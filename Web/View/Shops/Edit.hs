module Web.View.Shops.Edit where
import Web.View.Prelude

data EditView = EditView { shop :: Shop }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={ShopsAction}>Shops</a></li>
                <li class="breadcrumb-item active">Edit Shop</li>
            </ol>
        </nav>
        <h1>Edit Shop</h1>
        {renderForm shop}
    |]

renderForm :: Shop -> Html
renderForm shop = formFor shop [hsx|
    {(textField #name)}
    {(textField #groupId)}
    {submitButton}
|]
