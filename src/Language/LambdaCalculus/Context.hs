module Language.LambdaCalculus.Context
  ( Binding(..)
  , Context
  , addBinding
  , ctxLength
  , getBinding
  , getTypeFromContext
  , indexToName
  , pickFreshName
  ) where

import Language.LambdaCalculus.AST
import Language.LambdaCalculus.Types

data Binding =
    NameBind
  | VarBind Ty
  deriving (Show)

type Context = [(String, Binding)]

ctxLength :: Context -> Int
ctxLength = length

addBinding :: Context -> (String, Binding) -> Context
addBinding = flip (:)

getTypeFromContext :: Info -> Context -> Int -> Ty
getTypeFromContext fi ctx n =
  case getBinding ctx n of
    (VarBind tyT) -> tyT
    _ -> error $ "getTypeFromContext: Wrong kind of binding for variable " ++ indexToName fi ctx n

indexToName :: Info -> Context -> Int -> String
indexToName _ ctx n = fst $ ctx !! n

getBinding :: Context -> Int -> Binding
getBinding ctx n = snd $ ctx !! n

pickFreshName :: Context -> String -> (Context, String)
pickFreshName ctx x
  | x `elem` map fst ctx = pickFreshName ctx $ x ++ "'"
  | otherwise = ((x, NameBind) : ctx , x)
