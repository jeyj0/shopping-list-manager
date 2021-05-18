module Web.Controller.EatingPlans where

import Web.Controller.Prelude
import Web.View.EatingPlans.Index
import Web.View.EatingPlans.New
import Web.View.EatingPlans.Edit
import Web.View.EatingPlans.Show

instance Controller EatingPlansController where
    action EatingPlansAction = do
        eatingPlan <- query @EatingPlan |> fetch
        render IndexView { .. }

    action NewEatingPlanAction { groupId } = do
        let eatingPlan = newRecord
              |> set #groupId groupId
        render NewView { .. }

    action ShowEatingPlanAction { eatingPlanId } = do
        eatingPlan <- fetch eatingPlanId
        render ShowView { .. }

    action EditEatingPlanAction { eatingPlanId } = do
        eatingPlan <- fetch eatingPlanId
        render EditView { .. }

    action UpdateEatingPlanAction { eatingPlanId } = do
        eatingPlan <- fetch eatingPlanId
        eatingPlan
            |> buildEatingPlan
            |> ifValid \case
                Left eatingPlan -> render EditView { .. }
                Right eatingPlan -> do
                    eatingPlan <- eatingPlan |> updateRecord
                    setSuccessMessage "EatingPlan updated"
                    redirectTo EditEatingPlanAction { .. }

    action CreateEatingPlanAction = do
        let eatingPlan = newRecord @EatingPlan
        eatingPlan
            |> buildEatingPlan
            |> ifValid \case
                Left eatingPlan -> render NewView { .. } 
                Right eatingPlan -> do
                    eatingPlan <- eatingPlan |> createRecord
                    setSuccessMessage "EatingPlan created"
                    redirectTo ShowGroupAction { groupId = get #groupId eatingPlan }

    action DeleteEatingPlanAction { eatingPlanId } = do
        eatingPlan <- fetch eatingPlanId
        deleteRecord eatingPlan
        setSuccessMessage "EatingPlan deleted"
        redirectTo EatingPlansAction

buildEatingPlan eatingPlan = eatingPlan
    |> fill @'["groupId", "name"]
