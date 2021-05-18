module Web.View.Ingredients.Edit where
import Web.View.Prelude

data EditView = EditView { ingredient :: Ingredient }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={IngredientsAction}>Ingredients</a></li>
                <li class="breadcrumb-item active">Edit Ingredient</li>
            </ol>
        </nav>
        <h1>Edit Ingredient</h1>
        {renderForm ingredient}
    |]

renderForm :: Ingredient -> Html
renderForm ingredient = formFor ingredient [hsx|
    {(textField #groupId)}
    {(textField #name)}
    {submitButton}
|]
