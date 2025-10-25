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