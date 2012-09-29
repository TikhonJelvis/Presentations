module Main where

import           Data.Functor                  ((<$>))
import           Data.Tree                     (drawForest)

import           Presentations.Parse

import           Text.ParserCombinators.Parsec (parseFromFile)

exampleFile = "/home/tikhon/Documents/programming/haskell/presentations/example.org"

test :: IO ()
test = do readFile exampleFile >>= putStrLn
          parsed <- parseFromFile outline exampleFile
          case parsed of
            Left e -> putStrLn "Error!" >> print e
            Right v -> do print v
                          putStrLn $ drawForest (fmap show <$> toTree v)
