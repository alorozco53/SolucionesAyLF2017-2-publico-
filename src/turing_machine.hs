{-- Práctica 3
-- Autómatas y Lenguajes Formales
-- 2017-2
-- Prof: Noé Salomón Hernández Sánchez
-- Ayudante: Albert Manuel Orozco Camacho
-- Ayudante: Cenobio Moisés Vázquez Reyes
-- Version: 0.1
-- Author1: AlOrozco53
--}

module TM where

-- | Basic types
type Simbolo = Char
type Estado = [Char]
type Alfabeto = [Simbolo]

-- | Ejercicio 1, TM motion values
data Movimiento = L -- izquierda
                | R -- derecha
                deriving (Show, Eq)

-- | Ejercicio 2, transition function type alias
type Delta = Estado -> Simbolo -> (Estado, Simbolo, Movimiento)

-- | Turing machine structure
data MaqT = MaqT { q :: [Estado],  -- conjunto de estados
                   q0 :: Estado,   -- estado inicial
                   qf :: Estado,   -- estado de aceptación
                   qr :: Estado,   -- estado de rechazo
                   s :: Alfabeto,  -- alfabeto de entrada
                   g :: Alfabeto   -- alfabeto de cinta
                 } deriving Show

-- | Turing machine definition
data MT = MT { mtupla :: MaqT,  -- Turing machine tuple structure
               dltfun :: Delta  -- transition function
             }


-- | Show functions for standard Turing Machines
pintaEstados :: [Estado] -> String
pintaEstados [] = ""
pintaEstados (l:le) = l ++ "  " ++ pintaEstados le

pintaEstado :: Estado -> String
pintaEstado e = e ++ ""

pintaAlfabeto :: Alfabeto -> String
pintaAlfabeto [] = ""
pintaAlfabeto (l:la) = [l] ++ " " ++ pintaAlfabeto la

-- | Auxiliar function to produce the cross product between
-- | a set of states and an alphabet
generaPares :: [Estado] -> Alfabeto -> [(Estado, Simbolo)]
generaPares le ls = [(e, s)| e <- le, s <- ls]

-- | Show functions for a TM delta function
pintaDeltaAux :: Delta -> [(Estado, Simbolo)] -> String
pintaDeltaAux _ [] = "\n"
pintaDeltaAux t ((e, s):xs) =
  case t e s of
      (e', s', m) -> "                        d " ++
                     e ++ " " ++ [s] ++ " = " ++ " " ++e' ++
                     " " ++ [s'] ++ " " ++ show m ++ "\n" ++ pintaDeltaAux t xs

pintaDelta :: [Estado] -> Alfabeto -> Delta -> String
pintaDelta le ls t = pintaDeltaAux t (generaPares le ls)

instance Show MT where
  show mt = "\nEstados:: "
            ++ pintaEstados (estados mt) ++ "\n" ++
            "\nEstado Inicial:: "
            ++ pintaEstado (estadoInicial mt) ++ "\n" ++
            "\nEstado de Aceptación:: "
            ++ pintaEstado (estadoAcept mt) ++ "\n" ++
            "\nEstado de Rechazo:: "
            ++ pintaEstado (estadoRechazo mt) ++ "\n" ++
            "\nAlfabeto de Entrada:: "
            ++ pintaAlfabeto (sigma mt) ++ "\n" ++
            "\nAlfabeto de la Cinta:: "
            ++ pintaAlfabeto (gamma mt) ++ "\n" ++
            "\nFunción de Transición::\n"
            ++ pintaDelta (estados mt) (gamma mt) d
    where
      d = funTransicion mt


shit = MaqT ["q0", "q1"] "q0" "q0" "q1" "01" "01_"
dshit = \state -> \input -> (state, '0', R)
shittm = MT shit dshit

-- | Gets the input alphabet from a Turing Machine
sigma :: MT -> Alfabeto
sigma = s . mtupla

-- | Gets the tape alphabet from a Turing Machine
gamma :: MT -> Alfabeto
gamma = g . mtupla

-- | Gets the state set from a Turing Machine
estados :: MT -> [Estado]
estados = q . mtupla

-- | Gets the initial state from a Turing Machine
estadoInicial :: MT -> Estado
estadoInicial = q0 . mtupla

-- | Gets the accepting state from a Turing Machine
estadoAcept :: MT -> Estado
estadoAcept = qf . mtupla

-- | Gets the rejecting state from a Turing Machine
estadoRechazo :: MT -> Estado
estadoRechazo = qr . mtupla

-- | Gets the transition function
funTransicion :: MT -> Delta
funTransicion = dltfun


-- | Ejercicio 3, TM that accepts binary strings with even number of 0's
tmPares :: MT
tmPares = MT (MaqT states initState acceptState rejectState inpAlphabet tapeAlphabet) deltaFun
  where
    states = ["q" ++ [c] | c <- "01fr"]
    initState = "q0"
    acceptState = "qf"
    rejectState = "qr"
    inpAlphabet = "01"
    tapeAlphabet = "01_"
    deltaFun = \q -> \a -> case (q, a) of
                             ("q0", '0') -> ("q1", '_', R)
                             ("q0", '1') -> ("q0", '_', R)
                             ("q1", '0') -> ("q0", '_', R)
                             ("q1", '1') -> ("q1", '_', R)
                             ("q0", '_') -> ("qf", '_', R)
                             ("q1", '_') -> ("qr", '_', R)
                             (qfinal, _) -> (qfinal, '_', R)


-- | Flips 0s to 1s and 1s to 0s
-- | Accepts (01)+0
flippingTM :: MT
flippingTM = MT (MaqT states initState acceptState rejectState inpAlphabet tapeAlphabet) deltaFun
  where
    states = ["q" ++ [c] | c <- "01fr"]
    initState = "q0"
    acceptState = "qf"
    rejectState = "qr"
    inpAlphabet = "01"
    tapeAlphabet = "01_"
    deltaFun = \q -> \a -> case (q, a) of
                             ("q0", '0') -> ("q1", '1', R)
                             ("q1", '1') -> ("q0", '0', R)
                             ("q1", '_') -> ("qf", '_', R)
                             (_, c) -> ("qr", c, R)


-- | Ejercicio 4, TM for a^n b^n c^n
tmanbncn :: MT
tmanbncn = MT (MaqT states initState acceptState rejectState inpAlphabet tapeAlphabet) deltaFun
  where
    states = ["q" ++ [c] | c <- "123456789"] ++ ["s", "q10", "t", "r"]
    initState = "s"
    acceptState = "t"
    rejectState = "r"
    inpAlphabet = "abc"
    tapeAlphabet = "abc[_]"
    deltaFun = \q -> \a -> case (q, a) of
                             -- first phase
                             ("s", '[') -> ("s", '[', R)
                             ("s", 'a') -> ("s", 'a', R)
                             ("s", 'b') -> ("q1", 'b', R)
                             ("s", 'c') -> ("q2", 'c', R)
                             ("s", '_') -> ("q3", ']', L)
                             ("s", ']') -> ("r", ']', R)
                             ("q1", '[') -> ("r", '[', R)
                             ("q1", 'a') -> ("r", 'a', R)
                             ("q1", 'b') -> ("q1", 'b', R)
                             ("q1", 'c') -> ("q2", 'c', R)
                             ("q1", '_') -> ("q3", ']', L)
                             ("q1", ']') -> ("r", ']', R)
                             ("q2", '[') -> ("r", '[', R)
                             ("q2", 'a') -> ("r", 'a', R)
                             ("q2", 'b') -> ("r", 'b', R)
                             ("q2", 'c') -> ("q2", 'c', R)
                             ("q2", '_') -> ("q3", ']', L)
                             ("q2", ']') -> ("r", ']', R)
                             -- second phase
                             ("q3", '[') -> ("t", '[', R)
                             ("q3", 'a') -> ("r", 'a', R)
                             ("q3", 'b') -> ("r", 'b', R)
                             ("q3", 'c') -> ("q4", 'c', L)
                             ("q3", '_') -> ("q3", '_', L)
                             ("q3", ']') -> ("r", ']', R)
                             ("q4", '[') -> ("r", '[', R)
                             ("q4", 'a') -> ("r", 'a', R)
                             ("q4", 'b') -> ("q5", '_', L)
                             ("q4", 'c') -> ("q4", 'c', L)
                             ("q4", '_') -> ("q4", '_', L)
                             ("q4", ']') -> ("r", ']', R)
                             ("q5", '[') -> ("r", '[', R)
                             ("q5", 'a') -> ("q6", '_', L)
                             ("q5", 'b') -> ("q5", 'b', L)
                             ("q5", 'c') -> ("r", 'c', R)
                             ("q5", '_') -> ("q5", '_', L)
                             ("q5", ']') -> ("r", ']', R)
                             ("q6", '[') -> ("q7", '[', R)
                             ("q6", 'a') -> ("q6", 'a', L)
                             ("q6", 'b') -> ("r", 'b', R)
                             ("q6", 'c') -> ("r", 'c', R)
                             ("q6", '_') -> ("q6", '_', L)
                             ("q6", ']') -> ("r", ']', R)
                             -- third phase
                             ("q7", '[') -> ("r", '[', R)
                             ("q7", 'a') -> ("q8", '_', R)
                             ("q7", 'b') -> ("r", 'b', R)
                             ("q7", 'c') -> ("r", 'c', R)
                             ("q7", '_') -> ("q7", '_', R)
                             ("q7", ']') -> ("t", ']', R)
                             ("q8", '[') -> ("r", '[', R)
                             ("q8", 'a') -> ("q8", 'a', R)
                             ("q8", 'b') -> ("q9", '_', R)
                             ("q8", 'c') -> ("r", 'c', R)
                             ("q8", '_') -> ("q8", '_', R)
                             ("q8", ']') -> ("r", ']', R)
                             ("q9", '[') -> ("r", '[', R)
                             ("q9", 'a') -> ("r", 'a', R)
                             ("q9", 'b') -> ("q9", 'b', R)
                             ("q9", 'c') -> ("q10", '_', R)
                             ("q9", '_') -> ("q9", '_', R)
                             ("q9", ']') -> ("r", ']', R)
                             ("q10", '[') -> ("r", '[', R)
                             ("q10", 'a') -> ("r", 'a', R)
                             ("q10", 'b') -> ("r", 'b', R)
                             ("q10", 'c') -> ("q10", 'c', R)
                             ("q10", '_') -> ("q10", '_', R)
                             ("q10", ']') -> ("q3", ']', L)
                             -- accepting and rejecting states
                             ("t", c) -> ("t", c, R)
                             ("r", c) -> ("r", c, R)


-- | Configuration-useful types
type Cadena = [Simbolo]
type Configuracion = (Estado, Cadena, Int)

-- | This function takes a string str, an integer i, and a symbol s
-- | and substitutes s in the i-th position of str
sustituye :: Cadena -> Int -> Simbolo -> Cadena
sustituye [] _ _ = []
sustituye (w:ws) 0 a = a:ws
sustituye (w:ws) n a
  | n < 0 = error "invalid index!"
  | otherwise = w: sustituye ws (n-1) a

-- | Ejercicio 5, delta function
delta :: Delta -> Configuracion -> Configuracion
delta d (q, w, n)
  | n == (length w) - 1 = case d q nthSymb of
                      (p, s, L) -> (p, subs s, n - 1)
                      (p, s, R) -> (p, subs s ++ "_", n + 1)
  | n == 0 = case d q nthSymb of
               (p, s, L) -> (p, subs s, 0)
               (p, s, R) -> (p, subs s, 1)
  | otherwise = case d q nthSymb of
                  (p, s, L) -> (p, subs s, n - 1)
                  (p, s, R) -> (p, subs s, n + 1)
  where
    nthSymb = w !! n
    subs s = sustituye w n s


-- | Closure for delta function
deltaEstrella :: MT -> Configuracion -> Bool
deltaEstrella mt (q, w, n)
  | q == estadoAcept mt = True
  | q == estadoRechazo mt = False
  | otherwise = deltaEstrella mt (delta d (q,w,n))
  where
    d = funTransicion mt

-- | Ejercicio 6, decides if the given string is accepted by the given TM
aceptaCadena :: MT -> Cadena -> Bool
aceptaCadena mt string = deltaEstrella mt (estadoInicial mt, string, 0)

-- | Auxiliar for Kleene star operation
kln :: Alfabeto -> Int -> [Cadena]
kln s 0 = [" "]
kln s n
  | n < 0 = error "invalid index!"
  | otherwise = [a:w | a <- s , w <- kln s (n-1)]

-- | Kleene star of an alphabet
klns :: Alfabeto -> [Cadena]
klns s = concat [kln s n | n <- [0..] ]

-- | Ejercicio 7, lazy construction of the language accepted by a TM
lenguajeAceptado :: MT -> [Cadena]
lenguajeAceptado = error "to be implemented..."
