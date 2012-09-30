module Main where

import           Data.Functor                  ((<$>))
import           Data.List                     (intercalate)
import           Data.Tree                     (drawForest)

import           Presentations.Output
import           Presentations.Parse

import           System.Environment            (getArgs)

import           Text.ParserCombinators.Parsec (parseFromFile)

main :: IO ()
main = getArgs >>= go
  where go [file] = do parsed <- parseFromFile outline file
                       case parsed of
                         Left  err -> putStrLn "Parse error!" >> print err
                         Right res -> writeFile (file ++ ".html") output
                           where output = intercalate "\n" $ slideToDiv <$> res
        go _      = putStrLn "Usage: `presentations <file>' where <file> is a file path."


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
