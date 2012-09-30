module Main where

import           Data.Functor                  ((<$>))
import           Data.Tree                     (drawForest)

import           Presentations.Output
import           Presentations.Parse

import           Text.ParserCombinators.Parsec (parseFromFile)

exampleFile = "/home/tikhon/Documents/programming/haskell/presentations/example.org"

test :: IO ()
test = do parsed <- parseFromFile outline exampleFile
          case parsed of
            Left e -> putStrLn "Error!" >> print e
            Right v -> do print v
                          putStrLn $ drawForest (fmap show <$> v)

test2 :: IO ()
test2 = do parsed <- parseFromFile outline exampleFile
           case parsed of
             Left e -> putStrLn "Error!" >> print e
             Right v -> do print v
                           mapM_ (putStrLn . slideToDiv) v
