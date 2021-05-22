module Web.View.Shops.New where
import Web.View.Prelude

data NewView = NewView { shop :: Shop }

instance View NewView where
    html NewView { .. } = [hsx|
        <nav>
            <a href={DashboardAction} class="mr-4">Dashboard</a>
            <a href={groupHref}>Back to Group</a>
        </nav>
        <h1>New Shop</h1>
        {renderForm shop}
    |]
      where
        groupHref = pathTo ShowGroupAction { groupId = get #groupId shop }

renderForm :: Shop -> Html
renderForm shop = formFor shop [hsx|
    {(textField #name)}
    {(hiddenField #groupId)}
    {submitButton}
|]
