module Web.View.Ingredients.New where
import Web.View.Prelude

data NewView = NewView { ingredient :: Ingredient }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={IngredientsAction}>Ingredients</a></li>
                <li class="breadcrumb-item active">New Ingredient</li>
            </ol>
        </nav>
        <h1>New Ingredient</h1>
        {renderForm ingredient}
    |]

renderForm :: Ingredient -> Html
renderForm ingredient = formFor ingredient [hsx|
    {(hiddenField #groupId)}
    {(textField #name)}
    {submitButton}
|]
