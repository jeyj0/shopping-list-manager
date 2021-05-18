module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types
import IHP.LoginSupport.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController
  = StartPageAction
  deriving (Eq, Show, Data)

instance HasNewSessionUrl User where
  newSessionUrl _ = "/NewSession"

type instance CurrentUserRecord = User

data SessionsController
  = NewSessionAction
  | CreateSessionAction
  | DeleteSessionAction
  deriving (Eq, Show, Data)

data UsersController
    = DashboardAction
    | NewUserAction
    | CreateUserAction
    | DeleteUserAction { userId :: !(Id User) }
    deriving (Eq, Show, Data)

data GroupsController
    = NewGroupAction
    | ShowGroupAction { groupId :: !(Id Group) }
    | CreateGroupAction
    | DeleteGroupAction { groupId :: !(Id Group) }
    deriving (Eq, Show, Data)

data InvitationsController
    = InvitationsAction
    | NewInvitationAction { groupId :: !(Id Group) }
    | ShowInvitationAction { invitationId :: !(Id Invitation) }
    | CreateInvitationAction
    | AcceptInvitationAction { invitationId :: !(Id Invitation) }
    | DeclineInvitationAction { invitationId :: !(Id Invitation) }
    | DeleteInvitationAction { invitationId :: !(Id Invitation) }
    deriving (Eq, Show, Data)

data IngredientsController
    = IngredientsAction
    | NewIngredientAction { groupId :: !(Id Group) }
    | ShowIngredientAction { ingredientId :: !(Id Ingredient) }
    | CreateIngredientAction
    | EditIngredientAction { ingredientId :: !(Id Ingredient) }
    | UpdateIngredientAction { ingredientId :: !(Id Ingredient) }
    | DeleteIngredientAction { ingredientId :: !(Id Ingredient) }
    deriving (Eq, Show, Data)

data RecipesController
    = RecipesAction
    | NewRecipeAction { groupId :: !(Id Group) }
    | ShowRecipeAction { recipeId :: !(Id Recipe) }
    | CreateRecipeAction
    | EditRecipeAction { recipeId :: !(Id Recipe) }
    | UpdateRecipeAction { recipeId :: !(Id Recipe) }
    | AddIngredientAction { recipeId :: !(Id Recipe) }
    | DeleteRecipeAction { recipeId :: !(Id Recipe) }
    deriving (Eq, Show, Data)

data EatingPlansController
    = EatingPlansAction
    | NewEatingPlanAction { groupId :: !(Id Group) }
    | ShowEatingPlanAction { eatingPlanId :: !(Id EatingPlan) }
    | CreateEatingPlanAction
    | EditEatingPlanAction { eatingPlanId :: !(Id EatingPlan) }
    | UpdateEatingPlanAction { eatingPlanId :: !(Id EatingPlan) }
    | AddEatingPlanRecipeAction { eatingPlanId :: !(Id EatingPlan) }
    --  | RemoveEatingPlanRecipeAction { eatingPlanRecipeId :: !(Id EatingPlanRecipe) }
    | DeleteEatingPlanAction { eatingPlanId :: !(Id EatingPlan) }
    deriving (Eq, Show, Data)

data ShoppingListsController
    = ShoppingListsAction
    | NewShoppingListAction { groupId :: !(Id Group) }
    | ShowShoppingListAction { shoppingListId :: !(Id ShoppingList) }
    | CreateShoppingListAction
    | EditShoppingListAction { shoppingListId :: !(Id ShoppingList) }
    | UpdateShoppingListAction { shoppingListId :: !(Id ShoppingList) }
    | AddShoppingListEatingPlanAction { shoppingListId :: !(Id ShoppingList) }
    | AddExtraItemAction { shoppingListId :: !(Id ShoppingList) }
    | DeleteShoppingListAction { shoppingListId :: !(Id ShoppingList) }
    deriving (Eq, Show, Data)
