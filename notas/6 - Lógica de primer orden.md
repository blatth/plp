# Lógica de primer orden

## Sintaxis de la lógica de primer orden

Un lenguaje $L$ de primer orden está dado por:

1. Un conjunto de símbolos de funcion $F$ = `{f, g, h, ...}`
2. Un conjunto de símbolos de predicado $P$ = `{P, Q, R, ...}`

Ambos símbolos con aridad ≥ 0.

### Términos de primer orden

Un conjunto $T$ de términos se define por la siguiente gramática:

$$t ::= x \ | \ f(t_1,...,t_n)  $$

donde:

- $x$ denota una variable
- $f$ denota un símbolo de funcion con aridad ≥ 0

Se puede interpretar la **_aridad_** como "cuántos elementos se le pasan al símbolo"

### Ejemplo de términos sobre el lenguaje Lₐᵣᵢₜₘ

$$+(0,succ(x))$$

$$*(+(x,y),z)$$

### Fórmulas de primer orden

★ Tener cuidado: evitar la captura de variables, al igual que en _cálculo λ_

## Deducción natural para lógica de primer orden

### Deducción natural

- **Contexto**: Γ
- **Secuente**: Γ ⊢ σ

(lo mismo que λ)

Acá dejo el [machete](../../Recursos/Machete-DNatLPO.pdf) de las reglas de deducción natural pero en LPO.

---

- $I$ = regla de introducción
  - $X \notin fv(\Gamma)$ significa que X no aparezca como _variable libre_ en el contexto, es decir, que no haya condiciones que limiten la variable dentro de la deducción de una regla en ese contexto. En este caso es usado en la definición de $\forall_I$.
- $E$ = regla de eliminación
  - $X \notin fv(\Gamma, τ)$ sigue la misma noción que lo anterior. En este caso es usado en la definición de $\exists_E$.

#### Cuantificación universal

##### Ejemplo 1

```haskell
--------------------------------------- AX
∀X . (P(X) ∧ Q(X)) ⊢ ∀X . (P(X) ∧ Q(X))
------------------------------------------- ∀E
∀X . (P(X) ∧ Q(X)) ⊢ P(cos(X)) ∧ Q(cos(X))
------------------------------ ∧E_1
∀X . (P(X) ∧ Q(X)) ⊢ P(cos(X))
----------------------------------- ∀I
∀X . (P(X) ∧ Q(X)) ⊢ ∀X . P(cos(X))
-------------------------------------- ⇒I
⊢ ∀X . (P(X) ∧ Q(X)) ⇒ ∀X . P(cos(X))
```

#### Ejemplo 2

```haskell
------------------------------------------ AX
P(X), ∀X . ∀Y . Q(X, Y) ⊢ ∀Z. ∀Y . Q(Z, Y)
------------------------------------- ∀E
P(X), ∀X . ∀Y . Q(X, Y) ⊢ ∀Y. Q(Z, Y)
--------------------------------- ∀E 
P(X), ∀X . ∀Y . Q(X, Y) ⊢ Q(Z, Y) 
------------------------------------- ∀I
P(X), ∀X . ∀Y . Q(X, Y) ⊢ ∀Z. Q(Z, Y)           -- -> sustituyo X y ∀X por Z
----------------------------------------- ∀I
P(X), ∀X . ∀Y . Q(X, Y) ⊢ ∀Y. ∀X. Q(X, Y)
```

#### Cuantificación existencial

##### Ejemplo 1

```haskell
            ------------------------- AX
            σ, P(W, W), Q(X) ⊢ P(W, W) 
            ---------------------------- ⇒I
            σ, P(W, W) ⊢ Q(X) ⇒ P(W, W) 
            ----------------------------------- ∃I
            σ, P(W, W) ⊢ ∃Z. (Q(X) ⇒ P(W, Z)) 
----- ax    -------------------------------------- ∃I
σ ⊢ σ       σ, P(W, W) ⊢ ∃Y. ∃Z. (Q(X) ⇒ P(Y, Z))
----------------------------------------- ∃E
∃X W. P(W, W) ⊢ ∃Y. ∃Z. (Q(X) ⇒ P(Y, Z))

-- σ :≡ ∃W. P(W, W)
```
##### Ejemplo 2

```haskell

            ------------------------ AX
            σ, P(cos(X)) ⊢ P(cos(X))
            ------------------------------------ ∨I_1
            σ, P(cos(X)) ⊢ P(cos(X)) ∨ Q(cos(X)) 
----- AX    --------------------------------- ∃I
σ ⊢ σ       σ, P(cos(X)) ⊢ ∃X . (P(X) ∨ Q(X))
--------------------- ∃E
σ ⊢ ∃X. (P(X) ∨ Q(X)) 
------------------------------------ ⇒I
⊢ ∃X. P(cos(X)) ⇒ ∃X. (P(X) ∨ Q(X))

-- σ :≡ ∃X. P(cos(X))
```

## Práctica

## Prolog

Lo que no está declarado **_explícitamente_** va a devolver `false`.

```prolog
zombie(juan).
zombie(valeria).

tomo_mate_despues(juan,carlos).
tomo_mate_despues(clara,juan).

infectade(ernesto).
infectade(X) :- zombie(X).
infectade(X) :- zombie(Y), tomo_mate_despues(Y,X).      % acá sirve pensarlo como zombie(Y) && tomo_mate_despues(Y,X) ⇒ infectade(X)
```

La primer línea, es decir el primer axioma, puede interpretarse como $\forall X. zombie(X) \Rightarrow infectade(X)$

En el [Seguimiento de la consulta]() se puede ver el proceso de unificación el cual sigue Prolog para interpretar y devolver los valores correspondientes.

### Sintaxis

| Variable | Átomo | Término compuesto |
| -------- | ----- | ----------------- |
| Cualquier cosa que empiece con una mayúscula o "_" | Cualquier cosa que empiece con una mińuscula o esté entre comillas simples. Es la noción de átomo indivisible, no puede subdividirse en nada o sustituirse. Son constantes. | Cualquier cosa que sea un nombre seguido de n argumentos (los cuales también pueden ser variables), de los cuales cada uno es un término. _n_ es la aridad del término compuesto. También se lo llama **estructura**. |

#### Ejemplo 1

- Escribir el predicado `mayorA2(X)` que es verdadero cuando X > 2.

```prolog
natural(cero).
natural(suc(X)) :- natural(X).

mayorA2(suc(suc(suc(X)))) :- natural(X).
```

Cuando a esa porción de código se le tira cualquier variable que no esté declarada como natural, es decir, cualquier variable ≠ cero (porque se declaró `natural(cero)`), devuelve `false`.

Con la cuarta línea se declara que natural(X) es, como mínimo, 3.

#### Ejemplo 2

- Escribir el predicado menor(X, Y) que es verdadero cuando X < Y

```prolog
natural(cero).
natural(suc(X)) :- natural(X).

menor(cero, suc(X)) :- natural(X).      % cero siempre es el menor
menor(suc(X), suc(Y)) :- menor(X, Y) 
```

El caso donde Y = 0 no está definido, por lo que dará false. Se puede deducir por lo que está definido, además. Si le tiro algo como `menor(suc(cero), cero) = false`.

---

Ver diapos de unificación (MGU) y ejemplo de **amaLosGatos**.

Lo siguiente es el arbol:

```haskell
                        AMG(Z)
                          |
                    TM(Z,Y), G(Y)
                    |
                    |- {Z := John}      ]
                    |     &&            |- G(Garfield) -> true
                    |- {Y := Garfield}  ]
                    |
                    |- {Z := John}  ]
                    |     &&        |- G(Odie) -> false
                    |- {Y := Odie}  ]
                          

```
