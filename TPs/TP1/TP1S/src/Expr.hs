module Expr
  ( Expr (..),
    recrExpr,
    foldExpr,
    eval,
    armarHistograma,
    evalHistograma,
    mostrar,
  )
where

import Generador
import Histograma

-- | Expresiones aritméticas con rangos
data Expr
  = Const Float
  | Rango Float Float
  | Suma Expr Expr
  | Resta Expr Expr
  | Mult Expr Expr
  | Div Expr Expr
  deriving (Show, Eq)

recrExpr :: (Float -> a) -> (Float -> Float -> a) -> (Expr -> a -> Expr -> a -> a)  -> (Expr -> a -> Expr -> a -> a) -> (Expr -> a -> Expr -> a -> a) -> (Expr -> a -> Expr -> a -> a) -> Expr -> a
recrExpr fCons fRang fSum fRes fMul fDiv e  = case e of
                                  Const a   -> fCons a
                                  Rango a b -> fRang a b
                                  Suma a b  -> fSum a (rec a) b (rec b)
                                  Resta a b -> fRes a (rec a) b (rec b)
                                  Mult a b  -> fMul a (rec a) b (rec b)
                                  Div a b   -> fDiv a (rec a) b  (rec b)
                                  where
                                    rec     = recrExpr fCons fRang fSum fRes fMul fDiv

foldExpr :: (Float-> a) -> (Float -> Float -> a) -> (a -> a -> a)  -> (a -> a -> a) -> (a -> a -> a) -> (a -> a -> a) -> Expr -> a
foldExpr fCons fRang fSum fRes fMul fDiv e  = case e of
                                  Const a   -> fCons a
                                  Rango a b -> fRang a b
                                  Suma a b  -> fSum (rec a) (rec b)
                                  Resta a b -> fRes (rec a) (rec b)
                                  Mult a b  -> fMul (rec a) (rec b)
                                  Div a b   -> fDiv (rec a) (rec b)
                                  where
                                    rec     = foldExpr fCons fRang fSum fRes fMul fDiv

{-
liftM2 :: (Float -> Float -> Float) -> G Float -> G Float -> G Float
liftM2 f g1 g2 = \g ->
  let (x, g1') = g1 g
      (y, g2') = g2 g1'
   in (f x y, g2')

{-
liftM2 :: Monad m => (x -> y -> z) -> m x -> m y -> m z (https://learnyouahaskell.github.io/for-a-few-monads-more.html#useful-monadic-functions),
por lo que en mi caso m = G y x = y = z = Float
-}

-- | Evaluar expresiones dado un generador de números aleatorios
eval :: Expr -> G Float
eval =
  foldExpr
    (\ x g -> (x,g))
    (curry dameUno)
    (liftM2 (+))
    (liftM2 (-))
    (liftM2 (*))
    (liftM2 (/))
-}

-- | @armarHistograma m n f g@ arma un histograma con @m@ casilleros
-- a partir del resultado de tomar @n@ muestras de @f@ usando el generador @g@.
armarHistograma :: Int -> Int -> G Float -> G Histograma
armarHistograma m n f g =
  let (vals, g') = muestra f n g
      rango = rango95 vals
   in (histograma m rango vals, g')


-- | @evalHistograma m n e g@ evalúa la expresión @e@ usando el generador @g@ @n@ veces
-- devuelve un histograma con @m@ casilleros y rango calculado con @rango95@ para abarcar el 95% de confianza de los valores.
-- @n@ debe ser mayor que 0.
evalHistograma :: Int -> Int -> Expr -> G Histograma
evalHistograma m n e = armarHistograma m n (eval e)

-- Podemos armar histogramas que muestren las n evaluaciones en m casilleros.
-- >>> evalHistograma 11 10 (Suma (Rango 1 5) (Rango 100 105)) (genNormalConSemilla 0)
-- (Histograma 102.005486 0.6733038 [1,0,0,0,1,3,1,2,0,0,1,1,0],<Gen>)

-- >>> evalHistograma 11 10000 (Suma (Rango 1 5) (Rango 100 105)) (genNormalConSemilla 0)
-- (Histograma 102.273895 0.5878462 [239,288,522,810,1110,1389,1394,1295,1076,793,520,310,254],<Gen>)

-- | Mostrar las expresiones, pero evitando algunos paréntesis innecesarios.
-- En particular queremos evitar paréntesis en sumas y productos anidados.
mostrar :: Expr -> String
mostrar =
  recrExpr
    show                              -- Const

    (\a b -> show a ++ "∼" ++ show b) -- Rango

    (\_ sL _ sR -> sL ++ " + " ++ sR) -- Suma

    -- Resta
    (\eL sL eR sR ->
        maybeParen (constructor eL `elem` [CESuma, CEResta]) sL
        ++ " - " ++
        maybeParen (constructor eR `elem` [CESuma, CEResta]) sR)

    -- Multiplicación
    (\eL sL eR sR ->
        maybeParen (constructor eL == CEMult) sL
        ++ " * " ++
        maybeParen (constructor eR == CEMult) sR)

    -- División
    (\eL sL eR sR ->
        maybeParen (constructor eL `elem` [CESuma, CEResta, CEMult, CEDiv]) sL
        ++ " / " ++
        maybeParen (constructor eR `elem` [CESuma, CEResta, CEMult, CEDiv]) sR)



data ConstructorExpr = CEConst | CERango | CESuma | CEResta | CEMult | CEDiv
  deriving (Show, Eq)

-- | Indica qué constructor fue usado para crear la expresión.
constructor :: Expr -> ConstructorExpr
constructor (Const _) = CEConst
constructor (Rango _ _) = CERango
constructor (Suma _ _) = CESuma
constructor (Resta _ _) = CEResta
constructor (Mult _ _) = CEMult
constructor (Div _ _) = CEDiv

-- | Agrega paréntesis antes y después del string si el Bool es True.
maybeParen :: Bool -> String -> String
maybeParen True s = "(" ++ s ++ ")"
maybeParen False s = s
