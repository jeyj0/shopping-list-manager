module Web.View.Shops.Show where
import Web.View.Prelude

data ShowView = ShowView { shop :: Shop }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <a href={DashboardAction} class="mr-4">Dashboard</a>
            <a href={groupHref}>Back to Group</a>
        </nav>
        <h1>{get #name shop}</h1>
    |]
      where
        groupHref = pathTo ShowGroupAction { groupId = get #groupId shop }
