module Presentations.Types where

import           Data.Tree

data Level = Top | Middle | Bottom deriving (Show, Eq, Bounded, Enum, Ord)

data Item = Item { title  :: String
                 , text   :: [String]
                 , effect :: String} deriving (Show, Eq)

type Outline = Tree Item

data Style = Text | Bold | Italic | Underlined | Code | Strike | TeX deriving (Show, Eq)

type Styled = [(Style, String)]
