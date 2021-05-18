module Web.View.Ingredients.Index where
import Web.View.Prelude

data IndexView = IndexView { ingredients :: [Ingredient] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href={IngredientsAction}>Ingredients</a></li>
            </ol>
        </nav>
        <h1>Index</h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Ingredient</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach ingredients renderIngredient}</tbody>
            </table>
        </div>
    |]


renderIngredient ingredient = [hsx|
    <tr>
        <td>{ingredient}</td>
        <td><a href={ShowIngredientAction (get #id ingredient)}>Show</a></td>
        <td><a href={EditIngredientAction (get #id ingredient)} class="text-muted">Edit</a></td>
        <td><a href={DeleteIngredientAction (get #id ingredient)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
