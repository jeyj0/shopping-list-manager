module Web.View.Recipes.Index where
import Web.View.Prelude

data IndexView = IndexView { recipes :: [Recipe] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href={RecipesAction}>Recipes</a></li>
            </ol>
        </nav>
        <h1>Index</h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Recipe</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach recipes renderRecipe}</tbody>
            </table>
        </div>
    |]


renderRecipe recipe = [hsx|
    <tr>
        <td>{recipe}</td>
        <td><a href={ShowRecipeAction (get #id recipe)}>Show</a></td>
        <td><a href={EditRecipeAction (get #id recipe)} class="text-muted">Edit</a></td>
        <td><a href={DeleteRecipeAction (get #id recipe)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
