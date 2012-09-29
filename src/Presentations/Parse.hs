module Presentations.Parse where

import           Control.Applicative           ((*>))

import           Presentations.Types

import           Text.ParserCombinators.Parsec

outline :: Parser Outline
outline = undefined

item :: Parser Item
item = level *> undefined
  where level = string "*" <|> string "**" <|> string "***"
