
| Razonamiento ecuacional | Deducción natural                 |
| ----------------------- | --------------------------------- |
| Cap. 6 de Bird          | Cap. 2 y 6 de Sørensen y Urzyczyn |

---


```haskell
map f (map g xs) -> map (f . g) xs
```

Es válido afirmar esto en un lenguaje funcional, sin tener cuidado, ya que los maps no pueden tener efectos, entonces aplicarlos siempre será lo mismo. Al contrario que el _paradigma imperativo_.

### ¿Qué se va a asumir de ahora en más, para el razonamiento ecuacional y la inducción estructural?

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

![[Pasted image 20250905200237.png]]
## Inducción sobre booleanos

**Principio de inducción sobre booleanos**

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

**Principio de inducción sobre pares**

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
