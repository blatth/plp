
maximo :: Ord a => [a] -> a
maximo = foldr1 max

mejorSegun :: (a -> a -> Bool) -> [a] -> a
mejorSegun p = foldl1 (\x rec -> if p x rec then x else rec)

elems :: Eq a => a -> [a] -> Bool
elems e = foldr ((||).(==e)) False

take' :: [a] -> (Int -> [a])
take' []  = const []
take' (x:xs) = \n -> if n==0 then [] else x : take' xs (n-1)

take'' :: [a] -> (Int -> [a])
take'' = foldr (\x rec -> \n -> if n==0 then [] else x : rec (n-1)) (const [])

pares :: [(Int,Int)]
pares = [(x,s-x) | s <- [1..], x <- [1..s-1]]


listasQueSuman :: Int -> [[Int]]
listasQueSuman 0 = [[]]
listasQueSuman n | n > 0 = [x : xs | x <- [1..n], xs <- listasQueSuman (n-x)]

listas :: [[Int]]
listas = [xs | n <- [1..], xs <- listasQueSuman n]

listasJaja :: [[Int]]
listasJaja = concatMap listasQueSuman [1..]

data AEB a = Hoja a | Bin (AEB a) a (AEB a) deriving Show

aeb = Bin (Hoja 3) 5 (Bin (Hoja 7) 8 (Hoja 1))

foldAEB :: (b -> a -> b -> b)
        -> (a -> b)
        -> AEB a
        -> b
-- foldAEB f g (Hoja e)    = g e
-- foldAEB f g (Bin i r d) = f (rec i) r (rec d)
foldAEB f g t = case t of
    Hoja e    -> g e
    Bin i r d -> f (rec i) r (rec d)
  where
    rec = foldAEB f g

altura :: AEB a -> Int
altura = foldAEB (\ri _ rd -> 1 + (max ri rd)) (const 1) 

espejo :: AEB a -> AEB a
espejo = foldAEB (\recI r recD -> Bin recD r recI) Hoja

data Polinomio a = X
                 | Cte a
                 | Suma (Polinomio a) (Polinomio a)
                 | Prod (Polinomio a) (Polinomio a) 

--evaluar e X = e
--evaluar e (Cte c) = c
--evaluar e (Suma p1 p2) = (+) (evaluar e p1) (evaluar e p2)
--evaluar e (Prod p1 p2) = evaluar e p1 * evaluar e p2

foldPoli :: b
         -> (a -> b)
         -> (b -> b -> b)
         -> (b -> b -> b)
         -> Polinomio a
         -> b
foldPoli cX cCte cSuma cProd p = case p of
    X          -> cX
    Cte c      -> cCte c 
    Suma q1 q2 -> cSuma (rec q1) (rec q2)
    Prod q1 q2 -> cProd (rec q1) (rec q2)
  where
    rec = foldPoli cX cCte cSuma cProd

evaluar :: Num a => a -> Polinomio a -> a
evaluar e = foldPoli e id (+) (*)

pol = Suma (Prod X X) (Cte 1)

data RoseTree a = Rose a [RoseTree a] deriving Show

rose = Rose 3 [Rose 2 [],
               Rose 1 [Rose 5 []],
               Rose 4 []]

foldRose :: (a -> [b] -> b) -> RoseTree a -> b
foldRose f (Rose r rs) = f r (map rec rs)
  where
    rec = foldRose f
    
ramas :: RoseTree a -> [[a]]
ramas = foldRose (\x rec -> if null rec 
                            then [[x]]
                            else map (x:) (concat rec))
    
type Conj a = (a->Bool)

vacio :: Conj a -- a -> Bool
vacio = const False

insertar :: Eq a => a -> Conj a -> Conj a
insertar e c = \x -> e == x || c x

pertenece :: Eq a => a -> Conj a -> Bool
pertenece e c = c e

eliminar :: Eq a => a -> Conj a -> Conj a
eliminar e c = \x -> e /= x && c x  


