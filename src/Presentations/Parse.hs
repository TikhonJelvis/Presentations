module Presentations.Parse where

import           Control.Applicative           ((*>), (<$), (<$>), (<*), (<*>))

import           Data.List                     (intercalate)
import           Data.Tree                     (Tree (Node))

import           Presentations.Types

import           Text.ParserCombinators.Parsec

data Entry = Heading Level String
           | Paragraph String deriving (Show, Eq)

toTree :: [Entry] -> [Outline]
toTree = go
  where go [] = []
        go ((Heading level title) : rest) = currNode : go remainder
          where currNode = Node (Item title body) (toTree children)
                below (Heading level' _) = level' > level
                below Paragraph{}        = True
                isP Paragraph{} = True
                isP _           = False
                body = (\ (Paragraph p) -> p) <$> takeWhile isP rest
                children = takeWhile below $ dropWhile isP rest
                remainder = dropWhile below $ dropWhile isP rest

outline :: Parser [Entry]
outline = many1 block

block :: Parser Entry
block =  try heading
     <|> try paragraph

heading :: Parser Entry
heading = Heading <$> level <* spaces <*> title
  where level =  Bottom <$ try (string "***")
             <|> Middle <$ try (string "**")
             <|> Top    <$ string "*"
        title = many1 (noneOf "\n") <* many newline

paragraph :: Parser Entry
paragraph = Paragraph <$> body <* many newline
  where body = intercalate "\n" <$> line `sepEndBy1` newline

line :: Parser String
line = do notFollowedBy $ char '*'
          skipMany $ oneOf " \t"
          many1 (noneOf "\n")

emptyLines :: Parser ()
emptyLines = () <$ try (many $ skipMany (char ' ') *> newline)

eol :: Parser ()
eol = (() <$ newline) <|> eof
