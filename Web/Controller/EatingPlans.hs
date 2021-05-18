module Web.Controller.EatingPlans where

import Web.Controller.Prelude
import Web.View.EatingPlans.Index
import Web.View.EatingPlans.New
import Web.View.EatingPlans.Edit
import Web.View.EatingPlans.Show

findEatingPlanRecipes :: (?modelContext::ModelContext) => Id EatingPlan -> IO [Recipe]
findEatingPlanRecipes eatingPlanId = do
  let sql = "SELECT r.* " <>
            "FROM recipes AS r " <>
            "INNER JOIN eating_plan_recipes AS er ON er.recipe_id = r.id " <>
            "WHERE er.eating_plan_id = ?"
  sqlQuery sql $ Only eatingPlanId
  
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
        recipes <- findEatingPlanRecipes eatingPlanId
        availableRecipes <- query @Recipe
          |> findManyBy #groupId (get #groupId eatingPlan)
        render EditView { .. }

    action UpdateEatingPlanAction { eatingPlanId } = do
        eatingPlan <- fetch eatingPlanId
        eatingPlan
            |> buildEatingPlan
            |> ifValid \case
                Left eatingPlan -> do
                  recipes <- findEatingPlanRecipes eatingPlanId
                  availableRecipes <- query @Recipe
                    |> findManyBy #groupId (get #groupId eatingPlan)
                  render EditView { .. }
                Right eatingPlan -> do
                    eatingPlan <- eatingPlan |> updateRecord
                    setSuccessMessage "EatingPlan updated"
                    redirectTo EditEatingPlanAction { .. }

    action AddEatingPlanRecipeAction { eatingPlanId } = do
      let recipeId = param @(Id Recipe) "recipeId"
      newRecord @EatingPlanRecipe
            |> set #eatingPlanId eatingPlanId
            |> set #recipeId recipeId
            |> createRecord
      redirectTo EditEatingPlanAction { .. }
    
    -- action RemoveEatingPlanRecipeAction { eatingPlanRecipeId } = do
    --   deleteById eatingPlanRecipeId
    --   redirectTo EditEatingPlanAction { .. }

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
