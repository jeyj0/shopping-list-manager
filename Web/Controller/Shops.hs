module Web.Controller.Shops where

import Web.Controller.Prelude
import Web.View.Shops.Index
import Web.View.Shops.New
import Web.View.Shops.Edit
import Web.View.Shops.Show

instance Controller ShopsController where
    action ShopsAction = do
        shops <- query @Shop |> fetch
        render IndexView { .. }

    action NewShopAction { groupId } = do
        let shop = newRecord
              |> set #groupId groupId
        render NewView { .. }

    action ShowShopAction { shopId } = do
        shop <- fetch shopId
        render ShowView { .. }

    action EditShopAction { shopId } = do
        shop <- fetch shopId
        render EditView { .. }

    action UpdateShopAction { shopId } = do
        shop <- fetch shopId
        shop
            |> buildShop
            |> ifValid \case
                Left shop -> render EditView { .. }
                Right shop -> do
                    shop <- shop |> updateRecord
                    setSuccessMessage "Shop updated"
                    redirectTo EditShopAction { .. }

    action CreateShopAction = do
        let shop = newRecord @Shop
        shop
            |> buildShop
            |> ifValid \case
                Left shop -> render NewView { .. } 
                Right shop -> do
                    shop <- shop |> createRecord
                    setSuccessMessage "Shop created"
                    redirectTo ShowGroupAction { groupId = get #groupId shop }

    action DeleteShopAction { shopId } = do
        shop <- fetch shopId
        deleteRecord shop
        setSuccessMessage "Shop deleted"
        redirectTo ShopsAction

buildShop shop = shop
    |> fill @["name","groupId"]
