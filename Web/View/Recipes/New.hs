module Web.View.Recipes.New where
import Web.View.Prelude

data NewView = NewView { recipe :: Recipe }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={RecipesAction}>Recipes</a></li>
                <li class="breadcrumb-item active">New Recipe</li>
            </ol>
        </nav>
        <h1>New Recipe</h1>
        {renderForm recipe}
    |]

renderForm :: Recipe -> Html
renderForm recipe = formFor recipe [hsx|
    {(hiddenField #groupId)}
    {(textField #name)}
    <p>You will be able to add ingredients in the next step</p>
    {submitButton}
|]
