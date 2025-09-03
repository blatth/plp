-- Ejercicio 2

-- a 
valorAbsoluto :: Float -> Float
valorAbsoluto n | n < 0 = -n
                | otherwise = n

-- b
bisiesto :: Int -> Bool
bisiesto y = (y `mod` 400 == 0) || (y `mod` 4 == 0 && y `mod` 100 /= 0)

-- c
factorial :: Int -> Int
factorial 0 = 1
factorial f = f * factorial(f-1)

-- d
-- Recorro d desde 2 hasta n-1 y calculo n mod d == 0. Si null [algo] => False, si null [] => True => esPrimo = True
esPrimo :: Int -> Bool
esPrimo n = n > 1 && null [d | d <- [2..n-1], n `mod` d == 0]

-- Recorro d desde 1 hasta n y veo si se cumple n mod d == 0 y esPrimo d simultáneamente
cantDivisoresPrimos :: Int -> Int
cantDivisoresPrimos n = length [d | d <- [1..n], n `mod` d == 0, esPrimo d]


-- Ejercicio 3

-- a
inverso :: Float -> Maybe Float
inverso 0 = Nothing
inverso x = Just (1/x)

-- b
aEntero :: Either Int Bool -> Int
aEntero (Left m) = m
aEntero (Right b) = if b then 1 else 0