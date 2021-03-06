{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module Lib
    ( testFunc
    , routes
    , createTestTable
    ) where

import Data.Monoid ((<>))
import GHC.Generics

import Web.Scotty
import Network.Wai.Middleware.RequestLogger

import Data.Aeson (FromJSON, ToJSON)

-- SQLite
import Database.HDBC
import Database.HDBC.Sqlite3

import qualified Data.Text.Lazy as L


data Greeting = Greeting { message :: String } deriving (Show, Generic)

instance ToJSON Greeting
instance FromJSON Greeting


getDbName = "test.db"
getDbTable = "test"

defaultGreeting :: Greeting
defaultGreeting = Greeting { message = "Hello!" }

testFunc :: IO ()
testFunc = putStrLn "Test function"

routes :: ScottyM ()
routes = do
  enableDevLogging

  get "/hello" hello
  get "/info" info
  get "/greeting/:name" greeting
  get "/test" jsonTest
  get "/file" fileTest
  get "/db" dbTest

enableDevLogging :: ScottyM ()
enableDevLogging = middleware logStdoutDev

hello :: ActionM ()
hello = do
  text "hello world!"

info :: ActionM ()
info = do
  text "Guestbook info."

fileTest :: ActionM ()
fileTest = do
  str <- liftAndCatchIO $ readFile "test.txt"
  text $ L.pack str

dbTest :: ActionM ()
dbTest = do
  conn <- liftAndCatchIO $ connectSqlite3 getDbName
  liftAndCatchIO $ putStrLn "DB connected."
  liftAndCatchIO $ run conn ("SELECT * FROM " ++ getDbTable) []
  text "DB connected."

greeting :: ActionM ()
greeting = do
  nameParam <- param "name"
  let name = if nameParam == "" then "buddy" else nameParam
  text ("hello " <> name <> "!")

jsonTest :: ActionM ()
jsonTest = json defaultGreeting

createTestTable :: IO ()
createTestTable = do
  putStr $ "Connecting to DB: " <> getDbName <> "... "
  conn <- connectSqlite3 getDbName
  putStrLn "Done"

  putStr $ "Creating test DB: " <> getDbTable <> "... "
  run conn ("CREATE TABLE " <> getDbTable <> "(id INTEGER NOT NULL)") []
  commit conn
  putStrLn "Done"

  disconnect conn

  putStrLn "Table created."
