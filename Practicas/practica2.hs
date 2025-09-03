elem :: Eq a => a -> [a] -> Bool
elem e = foldr (\x rec -> x == e || rec) False

elem2 :: Eq a => a -> [a] -> Bool
elem2 e = foldr ((||).(==e)) False

{-Esto es recursión estructural, por lo que necesitamos el n para construir esta función. No es lo ideal.-}
take' :: [a] -> Int -> [a]
take' [] _ = []
take' (x:xs) n = if n == 0 then [] else x : take' xs (n-1)

{-Se puede reescribir así para sacarse de encima la n. Además, notar el uso de const, queda más declarativo-}
take'' :: [a] -> Int -> [a]
take'' [] = const []
take'' (x:xs) = \n -> if n == 0 then [] else x : take'' xs (n-1)

take2 :: [a] -> Int -> [a]
take2 = foldr (\x rec -> \n -> if n==0 then [] else x : rec (n-1)) (const [])

{-Ejemplo de recursión global-}
listasQueSuman :: Int -> [[Int]]
listasQueSuman 0 = [[]]
listasQueSuman n | n > 0 = [x:xs | x <- [1..n], xs <- listasQueSuman (n-x)]

fact :: Int -> Int
fact 0 = 1
fact n | n > 0 = n * fact(n-1)

pares :: [(Int, Int)]
pares = [(x, s-x) | s <- [1..], x <- [1..s-1]]

listas :: [[Int]]
listas = [xs | n <- [1..], xs <- listasQueSuman n]

data AEB a = Hoja a | Bin (AEB a) a (AEB a)
  deriving (Show)
ejemplo = Bin (Hoja 3) 5 (Bin (Hoja 7) 8 (Hoja 1))

foldAEB :: (b -> a -> b -> b) -> (a -> b) -> AEB a -> b
foldAEB fBin fHoja t = case t of
    Hoja n       -> fHoja n
    Bin t1 n t2  -> fBin (rec t1) n (rec t2)
  where
    rec = foldAEB fBin fHoja

altura :: AEB a -> Int
altura = foldAEB (\ri _ rd -> 1 + (max ri rd)) (const 1) -- caso base es el const.

espejo :: AEB a -> AEB a
espejo = foldAEB (\recI r recD -> Bin recD r recI) Hoja