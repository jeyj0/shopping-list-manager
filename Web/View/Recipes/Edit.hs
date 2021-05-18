module Web.View.Recipes.Edit where
import Web.View.Prelude

data EditView = EditView
  { recipe :: Recipe
  , group :: Group
  }

instance View EditView where
    html EditView { .. } = [hsx|
        <nav>
          <a href={DashboardAction} class="mr-4">Dashboard</a>
          <a href={showGroupHref}>{get #name group}</a>
        </nav>
        <h1>Edit Recipe</h1>
        {renderForm recipe}
    |]
      where
        showGroupHref = pathTo ShowGroupAction { groupId = get #id group }

renderForm :: Recipe -> Html
renderForm recipe = formFor recipe [hsx|
    {(hiddenField #groupId)}
    {(textField #name)}
    {submitButton}
|]
