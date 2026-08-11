# Razonamiento ecuacional

## Lecturas recomendadas

| Razonamiento ecuacional 				 | Deducción natural																						  |
| ----------------------- 				 | -----------------------------------------------------------------------------------------------------------|
| [Cap. 6 de Bird](../Recursos/Teo3.pdf) | [Cap. 1 Huth & Ryan](../Recursos/Teo3_2.pdf) - [Cap. 2 y 6 de Sørensen & Urzyczyn](../Recursos/Teo3_3.pdf) |

---

```haskell
map f (map g xs) -> map (f . g) xs
```

Es válido afirmar esto en un lenguaje funcional, sin tener cuidado, ya que los maps no pueden tener efectos, entonces aplicarlos siempre será lo mismo. Al contrario que el _paradigma imperativo_.

## ¿Qué se va a asumir de ahora en más, para el razonamiento ecuacional y la inducción estructural?

- Se trabajará con **tipos de datos inductivos** (o lo que es lo mismo, estructuras de datos finitas)
- Se trabajará con **funciones totales**
- Se trabajará asumienod que el programa **no depende** del orden de las ecuaciones, ex:
  
```haskell
	vacia [] = True -> vacia [] = True
	vacia _ = False -> vacia (_:_) = False
```

## Igualdades por definición

Si una igualdad se puede demostrar usando sólo el ==principio de reemplazo==, decimos que la igualdad vale **por definición**.

## Inducción estructural

**En el caso general**, se tendrán n casos base y m casos recursivos.

Se tiene el **principio de inducción estructural**:

> Sea $P$ una propiedad acerca de las expresiones tipo T tq:
> - $P$ Vale sobre todos los constructores base de T
> - $P$ vale sobre todos los constructores recursivos de T, asumiendo que la HI vale para los parámetros de tipo T.

**EJEMPLOS EN DIAPOS 15-18**: parece ser bastante mecánico, aunque hay detalles como el ejemplo del foldr/foldl.

### **Ejemplo de inducción sobre listas**

Para que se "destraben" las listas, conviene hacer inducción en `xs` ya que A0/A1 está definida con inducción en xs y M0/M1 también.

### **Ejemplo de relación entre foldr y foldl**

Lema.

$$Si \ g::b \rightarrow a \rightarrow b \rightarrow b, \ z::b, \ x::a, \ xs::[a], \ entonces$$
```haskell
foldl g < (xs ++ [x]) = g (foldl g z xs) x
```

## Inducción sobre booleanos

### **Principio de inducción sobre booleanos**

$$Si \: P(True) \ y \ P(False) \Rightarrow \forall x:: Bool. \ P(x)$$

Para este caso, el principio de reemplazo **no alcanza** para probar las equivalencias que necesitamos.

Un ejemplo simple es:

```haskell
not True = False  // {NF}
not False = True  // {NT}
```

Si quiero probar el enunciado:

$$\forall x::Bool. \: not(not \, x)=x$$ 
No puedo reemplazar directamente

## Inducción sobre pares

### **Principio de inducción sobre pares**

$$\forall x::a. \ \forall y::b. \ P((x,y)) \Rightarrow \forall p::(a,b). \ P(p)$$

## Inducción sobre naturales

**La misma noción de siempre.**

Demo:
Por ind. estructural en Nat, si

$$P(n) :=(suma \, n \, Zero = n)$$

basta ver que:

$$\forall n :: Nat. \, (P(n) \Rightarrow P(Suc \, n))$$

## Extensionalidad

Principio de extensionalidad funcional
$$Si \ (\forall x::a. \ f \ x = g \ x) \Rightarrow f = g$$

---

## Práctica

## Ejercicio 1

Tengo las siguientes propiedades:

```haskell
∀ F :: a -> b . ∀G :: a -> b . ∀Y :: b . ∀Z :: a

F = G       <=> ∀ x::a . F x = G x

F = \x -> Y <=> ∀ x::a . F x = Y

(\x -> Y) Z  =  β Y reemplazando x por Z

\x -> F x    =  η F
```

```haskell
curry :: ((a, b) -> c) -> (a -> b -> c)
{C} curry f = (\x y -> f (x, y))

uncurry :: (a -> b -> c) -> ((a, b) -> c)
{U} uncurry f = (\(x, y) -> f x y)

(.) :: (b -> c) -> (a -> b) -> (a -> c)
{COMP} (f . g) x = f (g x)

id :: a -> a
{I} id x = x
```

Si se quiere probar

```haskell
curry . uncurry = id
```

Se puede hacer de la siguiente forma, teniendo en cuenta las propiedades enumeradas.

```haskell
x :: a -> b -> c

(curry . uncurry) x = id x
curry (uncurry x)                  {-COMP-}
curry (\(x' y') -> x x' y')        {-U-} 
(\x'' y'' -> \(x' y') -> x x' y')  {-C-} 
(\x'' y'' -> x x'' y'')            {-η-}
(\x'' -> \y'' -> (x x'') y'')      {-η-}
(\x'' -> x x'')
η_ x = id x                        {-Lo que se quería probar-}

```

---
## Ejercicio 2

Si se tiene la siguiente definición de una función, que permite multiplicar pares y enteros entre sí (también usando **producto escalar**):

```haskell
prod :: Either Int (Int, Int) -> Either Int (Int, Int) -> Either Int (Int, Int)
prod (Left x) (Left y) = Left (x * y)                     {-P0-}
prod (Left x) (Right (y, z)) = Right (x * y, x * z)       {-P1-}
prod (Right (y, z)) (Left x) = Right (y * x, z * x)       {-P2-}
prod (Right (w, x)) (Right (y, z)) = Left (w * y + x * z) {-P3-}
```

¿Se puede probar esto?

```haskell
∀ p :: Either Int (Int, Int) . ∀ q::Either Int (Int, Int)

						prod p q = prod q p
```

Por **lema de generación**:

**PL**:

p :: Either Int (Int, Int) => ∃p = Left $x_1$ $\lor$ ∃p = Right $p_1$, con $x_1$ :: Int, $p_1$ :: (Int, Int)

**PR**:

$p_1$ :: (Int, Int)
∃$y_1$ :: Int, ∃$z_1$ :: Int, ∃$p_1$ :: ($y_1$, $z_1$)

**QL**: q = Left $x_2$ con $x_2$ :: Int
**QR**: q = Right ($y_2$, $z_2$) y ∃$y_2$ :: Int, ∃$z_2$ :: Int

Entonces, quiero probar `prod pq = prod qp`:

### **PL, QL: Caso 1** `

- p = Left $x_1$
- q = Left $x_2$

```haskell
prod (Left x_1) (Left x_2) = prod (Left x_2) (Left x_1)
Left (x_1 * x_2)                                        {-P0-}
prod (Left x_2) (Left x_1)                              {-Conmutativa-}
```

### **PL, QR: Caso 2** d

- p =  Left $x_1$
- q = Right ($y_2$, $z_2$)

```haskell
prod (Left x_1) (Right y_2, z_2) = prod (Right y_2, z_2) (Left x_1)
Right (x_1 * y_2, x_1 * z_2)                      {-P1-}
Right (y_2 * x_1, z_2 * x_1)                      {-Prop int-}
Right (y_2, z_2) (Left x_1)                       {-P2-}
```

### **PR, QR: Caso 3** 

- p = Right ($y_1$, $z_1$)
- q = Right ($y_2$, $z_2$)

```haskell
prod (Right (y_1, z_1)) (Right (y_2, z_2))
Left (y_1 * y_2 + z_1 + z_2)                     {-P3-}
Left (y_2 * y_1 + z_2 * z_1)                     {-Prop int-}
prod (Right (y_2, z_2)) (Right (x_1, z_1))       {-P3-}
```

---

## Ejercicio 3

**Por extensionalidad funcional**, alcanza con ver que:

∀ x :: a `Int d (dif c d) = vacio`

Por derecha:

```haskell
vacio x = (\z -> False x)      {-V-}
False                          {-β-}
```

Por izquierda

```haskell
int d (dif c d) x 
(\ e -> d e && (dif cd) e) x      {-I-}
dx && (dif cd) x                  {-β-}
dx && ((\e -> ce && not (de)) x)  {-D-}
dx && (cx && not (dx))            {-β-}
False                             {-Prop bool-}

□
```
