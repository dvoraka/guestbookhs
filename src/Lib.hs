{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( testFunc
    , routes
    ) where

import Data.Monoid ((<>))

import Web.Scotty


testFunc :: IO ()
testFunc = putStrLn "Test function"

routes :: ScottyM ()
routes = do
  get "/hello" hello
  get "/info" info
  get "/greeting/:name" greeting

hello :: ActionM ()
hello = do
  text "hello world!"

info :: ActionM ()
info = do
  text "Guestbook info."

greeting :: ActionM ()
greeting = do
  nameParam <- param "name"
  let name = if nameParam == "" then "buddy" else nameParam
  text ("hello " <> name <> "!")
