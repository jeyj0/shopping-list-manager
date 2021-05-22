module Web.View.Ingredients.Show where
import Web.View.Prelude

data ShowView = ShowView
  { ingredient :: Ingredient
  , selectedShops :: [Shop]
  , availableShops :: [Shop]
  }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={IngredientsAction}>Ingredients</a></li>
                <li class="breadcrumb-item active">Show Ingredient</li>
            </ol>
        </nav>
        <h1>{get #name ingredient}</h1>
        <h2>Available in shops:</h2>
        {renderShopsForm ingredient availableShops selectedShops}
    |]

renderShopsForm :: Ingredient -> [Shop] -> [Shop] -> Html
renderShopsForm ingredient availableShops selectedShops = [hsx|
  <form id="" method="POST" action={formAction} class="new-form">
    {forEach availableShops (renderShopCheckbox selectedShops)}
    <button class="btn btn-primary" type="submit">Save</button>
  </form>
|]
  where
    ingredientId = get #id ingredient
    formAction = pathTo SetPackagesAction { .. }

renderShopCheckbox :: [Shop] -> Shop -> Html
renderShopCheckbox selectedShops shop = [hsx|
  <div class="form-check">
    <input class="form-check-input" type="checkbox" checked={elem shop selectedShops} value={show shopId} name="shops" id={checkBoxId} />
    <label class="form-check-label" for={checkBoxId}>
      {get #name shop}
    </label>
  </div>
|]
  where
    shopId = get #id shop
    checkBoxId = "shop_check_" <> show shopId
