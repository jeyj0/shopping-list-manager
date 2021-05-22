module Web.View.Shops.Index where
import Web.View.Prelude

data IndexView = IndexView { shops :: [Shop] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href={ShopsAction}>Shops</a></li>
            </ol>
        </nav>
        <h1>Index</h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>Shop</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach shops renderShop}</tbody>
            </table>
        </div>
    |]


renderShop shop = [hsx|
    <tr>
        <td>{shop}</td>
        <td><a href={ShowShopAction (get #id shop)}>Show</a></td>
        <td><a href={EditShopAction (get #id shop)} class="text-muted">Edit</a></td>
        <td><a href={DeleteShopAction (get #id shop)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
