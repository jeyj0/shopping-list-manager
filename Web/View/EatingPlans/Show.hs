module Web.View.EatingPlans.Show where
import Web.View.Prelude

data ShowView = ShowView { eatingPlan :: EatingPlan }

instance View ShowView where
    html ShowView { .. } = [hsx|
        <nav>
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href={EatingPlansAction}>EatingPlans</a></li>
                <li class="breadcrumb-item active">Show EatingPlan</li>
            </ol>
        </nav>
        <h1>Show EatingPlan</h1>
        <p>{eatingPlan}</p>
    |]
