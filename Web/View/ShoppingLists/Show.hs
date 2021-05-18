module Web.View.ShoppingLists.Show where
import Web.View.Prelude

data ShowView = ShowView { shoppingList :: ShoppingList }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={ShoppingListsAction}>ShoppingLists</a></li>
                <li class="breadcrumb-item active">Show ShoppingList</li>
            </ol>
        </nav>
        <h1>Show ShoppingList</h1>
        <p>{shoppingList}</p>
    |]
