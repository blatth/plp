{-

-> Exercise F 

My wife has a book with the title EHT CDOORRSSW AAAGMNR ACDIINORTY. It contains lists of entries like this: 
6-letter words -------------- 
... 
eginor: ignore, region 
eginrr: ringer 
eginrs: resign, signer, singer 
... 
 
Yes, it is an anagram dictionary. The letters of the anagrams are sorted and the results are stored in dictionary order. 
Associated with each anagram are the English words with the same letters. Describe how you would go about designing a function 

anagrams :: Int -> [Word] -> String 

so that anagrams n takes a list of English words in alphabetical order, extracts just the n-letter words and produces a string that, when displayed, 
gives a list of the anagram entries for the n-letter words. 
You are not expected to be able to deﬁne the various functions; just give suitable names and types and describe what each of them is supposed to do.

-}

{-

Tengo que ordenar las palabras de longitud n (según el n dado) de acuerdo a una etiqueta asociada a cada una.
El orden debe ser alfabético

IDEA:
    - filtro qué palabras tienen longitud n
    - a cada palabra le asigno una etiqueta en la cual los chars de la etiqueta están ordenados alfabéticamente
    - ordeno las palabras según etiqueta
    - agrupo las palabras según etiqueta en una tupla (string, [string])
    - las formateo con algún map de modo que el display sea "string: [string]"
    - concateno todo

-}

{-

Supongo que tengo una lista de este estilo:

wordsList = ["ignore","region","ringer","resign","signer","singer"]

-}

import Data.List
import Data.Ord
import Prelude hiding (Word)

-- Renombre de tipos
type Word = String
type Label = String

-- Filtro cada word según sea el n dado. Verifico si len w = n => devuelvo una lista [w] donde len w = n
getWords :: Int -> [Word] -> [Word]
getWords n ws = filter (\w -> length w == n) ws 

-- Agrego una etiqueta a cada palabra, donde la etiqueta tiene ordenados alfabéticamente sus chars
addLbl :: Word -> (Label, Word)
addLbl w = (sort w, w)

-- Ordeno alfabéticamente por etiquetas
-- con fst selecciono la primer componente de las tuplas, con comparing comparo cada primer componente y después las ordeno con sortBy
sortLbls :: [(Label, Word)] -> [(Label, Word)]
sortLbls = sortBy (comparing fst)

-- Agrupo por etiquetas
-- Primero comparo las etiquetas y las agrupo si son iguales. Creo una lista para cada etiqueta
-- Luego, una vez agrupadas, con fst (head xs) extraigo la etiqueta de cada lista y con map snd xs mapeo todos los anagramas a esa etiqueta
-- El map de más afuera es para mapear en cada x de xs
groupByLbls :: [(Label, Word)] -> [(Label, [Word])]
groupByLbls = map (\xs -> (fst (head xs), map snd xs)) . groupBy (\(lbl1,_) (lbl2,_) -> lbl1 == lbl2)

-- Formateo para que se devuelva en modo de lista.
-- con wordsFormat chequeo: si es vacía, devuelve vacío. si es 1 elem, devuelvo el elem. sino hago llamada recursiva y devuelvo "w, "
-- dentro de displayFormat concateno los words formateados, luego concateno todo junto con su lbl correspondiente y un line break 
displayFormat :: (Label, [Word]) -> String
displayFormat (lbl, ws) = lbl ++ ": " ++ concat (wordsFormat ws) ++ "\n"
    where
        wordsFormat []      = []
        wordsFormat [w]     = [w]
        wordsFormat (w:ws)  = (w ++ ", ") : wordsFormat ws

-- Rec: se ejecuta de der a izq por el .
anagrams :: Int -> [Word] -> String
anagrams n = concat . map displayFormat . groupByLbls . sortLbls . map addLbl . getWords n

---------------------------------------


wordsList :: [Word]
wordsList = ["ignore","region","ringer","resign","signer","singer"]

test :: IO ()
test = putStrLn (anagrams 6 wordsList)
