{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE QuasiQuotes    #-}
module Presentations.Output where

import           Data.Tree                       (Tree (..))

import           Presentations.Markup
import           Presentations.Types

import           Text.Blaze.Html.Renderer.String (renderHtml)
import           Text.Hamlet                     (shamlet)

output :: [Outline] -> String
output = renderHtml . slidesToPresentation

slidesToPresentation slides = [shamlet|
$doctype 5
<html>
  <head>
    <title>
      Presentation
    ^{script "raphael.js"}
    ^{script "https://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.js"}
    ^{script "script.js"}
    <link rel="stylesheet" type="text/css" href="style.css">
  <body>
    <div#canvas_contain>
      $forall slide <- slides
        ^{slideToDiv slide}
|]

script src = [shamlet|<script type="text/javascript" src=#{src}>|]

slideToDiv (Node item children) = [shamlet|
<div class="slide hidden #{getEffect item}">
  <div.title>
    $forall tag <- map markedToTags (markup (title item))
      ^{tag}
  ^{childrenList children}
|]

getEffect :: Item -> String
getEffect Item {effect=""} = ""
getEffect Item {effect}    = "effects-" ++ effect

childrenList []       = [shamlet| |]
childrenList children = [shamlet|
<ul>
  $forall child <- children
    ^{pointToLi child}
|]

pointToLi (Node item children) = [shamlet|
<li>
  $forall tag <- map markedToTags (markup (title item))
    ^{tag}
  $forall paragraph <- text item
    <p>
      $forall tag <- map markedToTags (markup paragraph)
        ^{tag}
  ^{childrenList children}
|]

markedToTags (style, text) = case style of
  Text       -> [shamlet|#{text}|]
  Bold       -> [shamlet|<span.bold> #{text}|]
  Italic     -> [shamlet|<span.italic> #{text}|]
  Underlined -> [shamlet|<span.underlined> #{text}|]
  Code       -> [shamlet|<span.code> #{text}|]
  Strike     -> [shamlet|<span.strike> #{text}|]
  TeX        -> [shamlet|\\(#{text}\)|]
