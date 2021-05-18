module Web.View.ShoppingLists.Show where
import Web.View.Prelude

data ShowView = ShowView
  { shoppingList :: ShoppingList
  , items :: [Ingredient]
  }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
          <a href={DashboardAction} class="mr-4">Dashboard</a>
          <a href={groupHref}>Back to Group</a>
        </nav>
        <h1>Shopping List: {get #name shoppingList}</h1>
        <ul>
          {forEach items renderItem}
        </ul>
        <a href={editHref}>Edit</a>
    |]
      where
        groupHref = pathTo ShowGroupAction { groupId = get #groupId shoppingList }
        editHref = pathTo EditShoppingListAction { shoppingListId = get #id shoppingList }

renderItem :: Ingredient -> Html
renderItem item = [hsx|
  <li>{get #name item}</li>
|]
