module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)
import IHP.LoginSupport.Middleware
import Web.Controller.Sessions

-- Controller Imports
import Web.Controller.Categories
import Web.Controller.Shops
import Web.Controller.ShoppingLists
import Web.Controller.EatingPlans
import Web.Controller.Recipes
import Web.Controller.Ingredients
import Web.Controller.Invitations
import Web.Controller.Groups
import Web.Controller.Users
import Web.Controller.Static

instance FrontController WebApplication where
    controllers = 
        [ startPage StartPageAction
        , parseRoute @SessionsController
        -- Generator Marker
        , parseRoute @CategoriesController
        , parseRoute @ShopsController
        , parseRoute @ShoppingListsController
        , parseRoute @EatingPlansController
        , parseRoute @RecipesController
        , parseRoute @IngredientsController
        , parseRoute @InvitationsController
        , parseRoute @GroupsController
        , parseRoute @UsersController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
        initAuthentication @User
