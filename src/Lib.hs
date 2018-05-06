{-# LANGUAGE OverloadedStrings #-}

module Lib
    ( testFunc
    , routes
    ) where

import Web.Scotty


testFunc :: IO ()
testFunc = putStrLn "Test function"

routes :: ScottyM ()
routes = do
  get "/hello" hello
  get "/info" info

hello :: ActionM ()
hello = do
  text "hello world!"

info :: ActionM ()
info = do
  text "Guestbook info."
