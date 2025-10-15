# Cálculo λ

## Sintaxis

$$M ::= x\ | λ x:σ .M\ | MM\ | true\ | false\ | if\ M\ then\ M\ else\ M$$

- fv(x) = {x}
- fv(true) = ∅
- fv(false) =  ∅
- fv(if M ten N else O) = fv(M) ∪ fv(N) ∪ fv(O)
- fv(MN) = fv(M) ∪ fv(N)
- fv(λx:σ.M) = fv(M) \ {x} 
---
⟶ Todos los casos en donde haya un arbol son casos válidos, los casos donde no, no lo son
## a.  λx: Bool → Bool. x true

```java
lambda x: Bool -> Bool. x true
| abs
v
x true
|   | app
v   v
x   true
```

## b. x y λx: Bool → Bool. xy

- La última x está ligada a la λx, las demás son libres. Las ***x* son diferentes**, las variables que estén libres y se llamen iguales, **son lo mismo**, por lo que las *y* **son iguales**

```java
xy lambda x: Bool -> Bool. xy
| app             |
v                 v
xy          lambda x: Bool -> Bool. xy
|| app            | abs
vv                v
x y               xy
                  |
                  v app
                 x y
```

## c. (λx: Bool → Bool. x y)(λy: Bool. x)

```java
(lambda x: Bool -> Bool. x y)(lambda y: Bool. x)
| app                            |
v                                v
lambda x: Bool -> Bool. x y    lambda y: Bool. x
| abs                            | abs
v                                v
xy                               x
| app
v
x y
```

## d. λx: Bool

- Falta el cuerpo, **no es válido**

## e. λx:σ. x

- Falta la anotación de tipo, **no es válido**

## f. if x then y else λz: Bool. z

```java
if x then y else lambda z: Bool. z
|      |      | if
v      v      v
x      y      lambda z: bool. z
              | abs
              v
              z
``` 

## g. λy:σ. y

- $\sigma$ no es un tipo, por lo que **no es válido**

## h. true false

```java
true false
|      | app
v      v
true   false
```

- Está sintácticamente *bien*, pero **no tipa**

## i. x M

- M no es un término, por lo que **no es válido**

## j. if x then λx: Bool. x

- Falta la rama *else*, por lo que **no es válido**

---

# Tipado

El **contexto** tendrá asociaciones entre los tipos y las variables.

Los contextos **no tienen tipos repetidos ni tampoco letras repetidas**, ex:

**Γ₃** = y: Bool → Bool, y: Bool ⟶ esto **no** es válido.