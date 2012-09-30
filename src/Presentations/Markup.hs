{-# LANGUAGE TupleSections #-}
module Presentations.Markup where

import           Control.Applicative           (liftA2, (*>), (<$), (<$>), (<*))

import           Presentations.Types

import           Text.ParserCombinators.Parsec

markup :: String -> Styled
markup str = case parse marked "" str of
  Left e -> [(Text, str)]
  Right v -> v

marked :: Parser Styled
marked = many1 (try element <|> normal) <* eof

element :: Parser (Style, String)
element =  s '*' Bold
       <|> s '/' Italic
       <|> s '=' Code
       <|> s '`' Code
       <|> s '~' Code
       <|> s '_' Underlined
       <|> s '+' Strike
       <|> tex

s :: Char -> Style -> Parser (Style, String)
s c style = try $ (style,) <$> (char c *> many1 (noneOf [c]) <* char c)

tex :: Parser (Style, String)
tex = (TeX,) <$> (char '$' *> texCode <* char '$')
  where texCode = many1 $ try (char '\\' *> char '$') <|> noneOf "$"

normal :: Parser (Style, String)
normal = (Text,) <$> liftA2 (:) anyChar remainder
  where remainder = anyChar `manyTill` (() <$ lookAhead element <|> eof)
