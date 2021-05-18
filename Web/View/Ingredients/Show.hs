module Web.View.Ingredients.Show where
import Web.View.Prelude

data ShowView = ShowView { ingredient :: Ingredient }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={IngredientsAction}>Ingredients</a></li>
                <li class="breadcrumb-item active">Show Ingredient</li>
            </ol>
        </nav>
        <h1>Show Ingredient</h1>
        <p>{ingredient}</p>
    |]
