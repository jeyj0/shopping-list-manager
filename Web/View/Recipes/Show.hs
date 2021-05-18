module Web.View.Recipes.Show where
import Web.View.Prelude

data ShowView = ShowView { recipe :: Recipe }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={RecipesAction}>Recipes</a></li>
                <li class="breadcrumb-item active">Show Recipe</li>
            </ol>
        </nav>
        <h1>Show Recipe</h1>
        <p>{recipe}</p>
    |]
