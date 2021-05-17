module Web.View.Users.New where
import Web.View.Prelude

data NewView = NewView { user :: User }

instance View NewView where
    html NewView { .. } = [hsx|
      <div class="h-100" id="sessions-new">
        <div class="d-flex align-items-center">
          <div class="w-100">
            <div style="max-width: 400px" class="mx-auto mb-5">
              <h1>Register</h1>
              {renderForm user}
              <br>
              <a class="text-muted" href={pathTo NewSessionAction}>Already have an Account?</a>
            </div>
          </div>
        </div>
      </div>
    |]

renderForm :: User -> Html
renderForm user = formFor user [hsx|
    {(textField #email)}
    {(passwordField #passwordHash) { fieldLabel = "Password" }}
    {(hiddenField #failedLoginAttempts)}
    <button class="btn btn-primary" type="submit">Register</button>
|]
