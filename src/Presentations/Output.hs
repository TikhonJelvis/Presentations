{-# LANGUAGE QuasiQuotes #-}
module Presentations.Output where

import           Data.Tree                       (Tree (..))

import           Presentations.Markup
import           Presentations.Types

import           Text.Blaze.Html.Renderer.String (renderHtml)
import           Text.Hamlet                     (shamlet)

slideToDiv (Node item children) = renderHtml $ [shamlet|
<div.slide>
  <div class="title #{effect item}">
    $forall tag <- map markedToTags (markup (title item))
      ^{tag}
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
  <ul>
    $forall child <- children
      ^{pointToLi child}
|]

markedToTags (style, text) = case style of
  Text       -> [shamlet|#{text}|]
  Bold       -> [shamlet|<span.bold> #{text}|]
  Italic     -> [shamlet|<span.italic> #{text}|]
  Underlined -> [shamlet|<span.underlined> #{text}|]
  Code       -> [shamlet|<span.code> #{text}|]
  Strike     -> [shamlet|<span.strike> #{text}|]
  TeX        -> [shamlet|\\(#{text}\)|]
