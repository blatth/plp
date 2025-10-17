# Inferencia de tipos

- `(λx. isZero(x)) true` esto **no** tipa.
- `λx. succ(x)` esto **tipa**, además es de `Nat -> Nat`. Como no hay ninguna variable libre no nos importa el contexto.
- `λx. succ(y)` esto **tipa**, además es de `x₁ -> Nat`. Se debe agregar el contexto Γ = y :: `Nat`, ya que y es libre. El término va quedar como: `{y :: Nat} ⊢ λx :: x₁. succ(y) :: x₁ -> Nat`

Con algo de tipo `∅ ⊢ λx:: x₁`

## Inferir el juicio de las expresiones

### λx. y

`{y :: Y} ⊢ λx :: X. y :: X -> Y` 

### f true

`{f::Bool -> X} ⊢ f true :: X`

### isZero(x)

`{x :: Nat} ⊢ isZero(x) :: Bool`

## MGU

$$MGU \{X_2 \rightarrow X_1 \rightarrow Bool = X_2 \rightarrow X_3\}$$

```haskell
{Decompose} {x_2 ≟ x_2, x_1 -> Bool ≟ x_3}
{Delete}    {x_1 -> Bool ≟ x_3}
{Swap}      {x_3 ≟ x_1 -> Bool}
{Elim}      ∅                               -- acá tuve en cuenta que {x_3 := x_1 -> Bool}
```

---

$$MGU \{(X_2 \rightarrow X_1) \rightarrow Nat ≟ X_2 \rightarrow X_3 \}$$

```haskell
{Decompose}     {x_2 -> x_1 ≟ x_2, Nat ≟ x_3}
{Swap}          {x_2 ≟ x_2 -> x_1, Nat ≟ x_3}   -- antes de este swap ya se ve que falla
{Occurs-check}  Falla
```

---

$$MGU \{X_1 \rightarrow Bool ≟ Nat \rightarrow Bool, X_2 ≟ X_1 \rightarrow X_1 \}$$

```haskell
{Elim}      {x_1 -> Bool ≟ Nat -> Bool}         -- acá tuve en cuenta que {x_2 := x_1 -> x_1}
{Decompose} {x_1 ≟ Nat, Bool ≟ Bool}
{Decompose} {x_1 ≟ Nat}
{Elim}      ∅                                   -- acá tuve en cuenta que S₂ = {x_1 := Nat} ★
```

```haskell
★

S = S₂ ∘ S₁ = {x₁ := Nat} ∘ {x₂ := x₁ -> x₁} = {x₁ := Nat, x₂ := Nat -> Nat}

S₂(S₁(Xᵢ)) = S₂(Xᵢ) = Xᵢ
  i ≠ 2
  i ≠ 1

  = {x₁ := Nat, x₂ := Nat -> Nat}               -- este es el juicio de tipado más general
```

## Algoritmo ℑ

### Paso 1: Rectificación de términos

$$(λf. \ λx. \ f(f \ x))(λf. \ f)$$

$$x \ (λx. \ succ(x))$$

Primero, observo que no hay variables libres en l primera expresión ⇒ $FV = \emptyset$

Después, renombro

```haskell
Exp1:
(λf. λx. f(f x))(λg. g)

Exp2:
x(λx. succ(x)) ⟿ α-renombre ⟿ x(λy. succ(y))
```

### Paso 2: Notación

$$λf. \ λx. \ f(f \ x)$$
$$x(λy. \ succ(y))$$

```haskell
Exp1:
M₀ = λf::X_1. λx::X_2. f(f x)
Γ₀ = ∅

Exp2:
M₀ = x(λy::X_2. succ(y))
Γ₀ = {x::X_1}

```

### Todos los pasos

$$λf. \ λx. \ f(fx)$$

1. Rectificación ✓
2. Anotación
   1. M₀ = λf::X_f. λx::X. f(f x)
   2. Γ₀ = ∅
3. ℑ(∅ | λf::X_f. λx::X. f(f x))

```haskell
ℑ(∅ | λf::X_f. λx::X. f(f x))
            |
            |-
            |
ℑ(f::X_f | λx::X. f(f x))
            |
            |- (x -> X₂ | E)
            |
ℑ({f::X_f, x::X} | f(f x)) = (X_₂ | {X_f ≟ X_₁ -> X₂, X_f ≟ X -> X₁})             -- Γ = {f::X_f, x::X}, E = (X_₂ | {X_f ≟ X_₁ -> X₂, X_f ≟ X -> X₁})
            |
            |- ℑ(Γ | f)     = (X_f | ∅)
            |
            |- ℑ(Γ | f x)   = (X₁ | {X_f ≟ X -> X₁})
                |
                |- ℑ(Γ | f) = (X_f | ∅)
                |
                |- ℑ(Γ | x) = (X | ∅)
```

4. Unificación

Defino **S** = **MGU($E$)**

`{X_f ≟ X₁ -> X₂, X_f ≟ X -> X₁}`

```haskell
{Elim}      {X_1 -> X_2 ≟ X -> X₁}                  -- acá asumo que {X_f := X_1 -> X_2}
{Decompose} {X₁ ≟ X, X₂ ≟ X₁}
{Elim}      {X₂ ≟ X}                                -- acá asumo que {X₁ := X}
{Elim}      ∅                                       -- acá asumo que {X₂ := X}
```