module Presentations.Types where

import           Data.Tree

data Item = Item { title :: String
                 , text  :: Maybe String }

type Outline = Tree Item
