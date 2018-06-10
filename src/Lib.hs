{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Lib
    ( testFunc
    , routes
    ) where

import Data.Monoid ((<>))
import GHC.Generics

import Web.Scotty
import Data.Aeson (FromJSON, ToJSON)
-- SQLite
import Database.HDBC.Sqlite3

import qualified Data.Text.Lazy as L


data Greeting = Greeting { message :: String } deriving (Show, Generic)

instance ToJSON Greeting
instance FromJSON Greeting

defaultGreeting :: Greeting
defaultGreeting = Greeting { message = "Hello!" }

testFunc :: IO ()
testFunc = putStrLn "Test function"

routes :: ScottyM ()
routes = do
  get "/hello" hello
  get "/info" info
  get "/greeting/:name" greeting
  get "/test" jsonTest
  get "/file" fileTest

hello :: ActionM ()
hello = do
  text "hello world!"

info :: ActionM ()
info = do
  text "Guestbook info."

fileTest :: ActionM()
fileTest = do
  str <- liftAndCatchIO $ readFile "test.txt"
  text $ L.pack str

greeting :: ActionM ()
greeting = do
  nameParam <- param "name"
  let name = if nameParam == "" then "buddy" else nameParam
  text ("hello " <> name <> "!")

jsonTest :: ActionM ()
jsonTest = json defaultGreeting
