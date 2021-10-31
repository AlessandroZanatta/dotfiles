module Utils where

import Text.Printf
import Data.Char

-- Take each first element of each sublist in the given list
firsts [] = []
firsts [x:xs] = [x]
firsts ((x:xs):xss) = x: firsts xss

-- Read file composed of alphanumeric characters
readAlphaNumFile :: String -> IO String
readAlphaNumFile filename = do
    filecontent <- readFile filename
    return (filter isAlphaNum filecontent) :: IO String

-- Wrap the given string with the given font number tag
withFont :: String -> Int -> String
withFont logo fontNum =
  "<fn=" ++ show fontNum ++ ">" ++ logo ++ "</fn>"

-- Wrap with an action the given string
wrapWithAction :: String -> String -> String
wrapWithAction toWrap action = printf "<action=%s>%s</action>" action toWrap

-- Wrap with a color the given string
wrapWithColors :: String -> String -> String -> String
wrapWithColors toWrap fgColor bgColor = printf "<fc=%s,%s>%s</fc>" fgColor bgColor toWrap

-- Wrap with a color the given string
wrapWithFgColor :: String -> String -> String
wrapWithFgColor toWrap fgColor = printf "<fc=%s>%s</fc>" fgColor toWrap

--------------------------------------------------------------------------------
-- POWERLINE-LIKE TEMPLATE
--------------------------------------------------------------------------------

arrowRight      = "\xE0B0" `withFont` 2
arrowLeft       = "\xE0B2" `withFont` 2
emptyArrowRight = "\xE0B1" `withFont` 2
emptyArrowLeft  = "\xE0B3" `withFont` 2

data ArrowType = LeftArrow
  | RightArrow
  | EmptyLeftArrow
  | EmptyRightArrow
  | NoArrow
  deriving Eq

-- Create the arrow based on passed stuff
doArrow :: ArrowType -> String -> String -> String -> String -> String
doArrow arrowType content bg fg afterColor =
  case arrowType of
    LeftArrow       -> arrowTemplate bg afterColor arrowLeft ++ template
    RightArrow      -> template ++ arrowTemplate bg afterColor arrowRight
    EmptyLeftArrow  -> arrowTemplate afterColor bg emptyArrowLeft ++ template
    EmptyRightArrow -> template ++ arrowTemplate afterColor bg emptyArrowRight
    NoArrow         -> template
  where
    template = printf "<fc=%s,%s:0>%s</fc>" fg bg content
    arrowTemplate = printf "<fc=%s,%s>%s</fc>"
