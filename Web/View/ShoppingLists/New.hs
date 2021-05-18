module Web.View.ShoppingLists.New where
import Web.View.Prelude

data NewView = NewView { shoppingList :: ShoppingList }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
          <a href={DashboardAction} class="mr-4">Dashboard</a>
          <a href={groupHref}>Back to Group</a>
        </nav>
        <h1>New ShoppingList</h1>
        {renderForm shoppingList}
    |]
      where
        groupHref = pathTo ShowGroupAction { groupId = get #groupId shoppingList }

renderForm :: ShoppingList -> Html
renderForm shoppingList = formFor shoppingList [hsx|
    {(textField #name)}
    {(hiddenField #groupId)}
    {submitButton}
|]
