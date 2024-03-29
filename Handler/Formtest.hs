module Handler.FormTest where

import Import

data ItemForm = ItemForm
    { itemFormName      :: Text
    , itemFormPrice     :: Int
    , itemFormAvailable :: Bool
    , itemFormMemo      :: Maybe Text
    }
  deriving Show

itemForm :: Form ItemForm
itemForm = renderBootstrap $ ItemForm
    <$> areq textField "Name" (Just "こんにちは")
    <*> areq intField "Price" (Just 1)
    <*> areq boolField "Available" Nothing
    <*> aopt textField "Memo" Nothing

getFormTestR :: Handler RepHtml
getFormTestR = do
    (formWidget, formEnctype) <- generateFormPost itemForm
    let widget = $(widgetFile "form")
    defaultLayout widget

postFormTestR :: Handler RepHtml
postFormTestR = do
    ((formResult, formWidget), formEnctype) <- runFormPost itemForm
    case formResult of
        FormMissing -> liftIO $ print "Form MISSING"
        FormFailure ts -> liftIO $ print ts
        FormSuccess itemForm -> liftIO $ print itemForm
    defaultLayout $ $(widgetFile "form")
