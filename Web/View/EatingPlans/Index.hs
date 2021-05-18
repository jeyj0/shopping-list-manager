module Web.View.EatingPlans.Index where
import Web.View.Prelude

data IndexView = IndexView { eatingPlan :: [EatingPlan] }

instance View IndexView where
    html IndexView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item active"><a href={EatingPlansAction}>EatingPlans</a></li>
            </ol>
        </nav>
        <h1>Index</h1>
        <div class="table-responsive">
            <table class="table">
                <thead>
                    <tr>
                        <th>EatingPlan</th>
                        <th></th>
                        <th></th>
                        <th></th>
                    </tr>
                </thead>
                <tbody>{forEach eatingPlan renderEatingPlan}</tbody>
            </table>
        </div>
    |]


renderEatingPlan eatingPlan = [hsx|
    <tr>
        <td>{eatingPlan}</td>
        <td><a href={ShowEatingPlanAction (get #id eatingPlan)}>Show</a></td>
        <td><a href={EditEatingPlanAction (get #id eatingPlan)} class="text-muted">Edit</a></td>
        <td><a href={DeleteEatingPlanAction (get #id eatingPlan)} class="js-delete text-muted">Delete</a></td>
    </tr>
|]
