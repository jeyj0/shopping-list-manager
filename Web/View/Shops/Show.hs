module Web.View.Shops.Show where
import Web.View.Prelude

data ShowView = ShowView { shop :: Include "categories" Shop }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <a href={DashboardAction} class="mr-4">Dashboard</a>
            <a href={groupHref}>Back to Group</a>
        </nav>
        <h1>{get #name shop}</h1>
        <ul>
          {forEach (get #categories shop) renderCategory}
        </ul>
        <a href={newCategoryHref} class="btn btn-primary">New Category</a>
    |]
      where
        groupHref = pathTo ShowGroupAction { groupId = get #groupId shop }
        newCategoryHref = pathTo NewCategoryAction { shopId = get #id shop }

renderCategory :: Category -> Html
renderCategory category = [hsx|
  <li><a href={categoryHref}>{get #name category}</a></li>
|]
  where
    categoryHref = pathTo ShowCategoryAction { categoryId = get #id category }
