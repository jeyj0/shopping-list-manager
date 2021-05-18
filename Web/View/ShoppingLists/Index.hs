module Web.View.ShoppingLists.Index where
import Web.View.Prelude

data IndexView = IndexView { shoppingLists :: [ShoppingList] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href={ShoppingListsAction}>ShoppingLists</a></li>
            </ol>
        </nav>
        <h1>Index</h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>ShoppingList</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach shoppingLists renderShoppingList}</tbody>
            </table>
        </div>
    |]


renderShoppingList shoppingList = [hsx|
    <tr>
        <td>{shoppingList}</td>
        <td><a href={ShowShoppingListAction (get #id shoppingList)}>Show</a></td>
        <td><a href={EditShoppingListAction (get #id shoppingList)} class="text-muted">Edit</a></td>
        <td><a href={DeleteShoppingListAction (get #id shoppingList)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
