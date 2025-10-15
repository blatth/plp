>  [Diapos de la teórica](https://github.com/blatth/plp/blob/main/Teoricas/Teorica5.pdf)

Rama **semántica** de la materia.

El **cálculo lambda** se basa en construir funciones y aplicarlas: el fundamento de los lenguajes de programación *funcional*.

★ **Cálculo sigma**: usado para demostrar que el imperativo y el funcional son esencialmente lo mismo

★ **Lógica lineal**

---

# Cálculo- λᵇ : sintaxis y tipado

$\tau$, $\sigma$,... son letra utilizadas para darle nombre a diferentes tipos, por ej:

```haskell
 - Bool -> Bool
 - (Bool -> Bool) -> Bool -> Bool
 - Bool -> Bool -> (Bool -> Bool)
 - Bool -> (Bool -> Bool)
 - Bool
```

 Todos estos son **diferentes** ***tipos***, los cuales pueden designarse cada uno con una letra griega para identificarlos.

- Las letras $a, \ b, \ c, \ etc...$ serán utilizadas para ***variables***.
- Las letras $A, \ B, \ C, \ etc...$ serán utilizadas para ***términos***.


$$λ x : \tau. M$$

$M$ es el ***cuerpo*** y para que $x$ esté ligada, debe aparecer dentro del *cuerpo*.
En la diapo 8 está detallado.

---

$\vdash$ :  se usa para decir "bajo cualquier contexto" de la letra que lo precede, ej:
$$ 
Γ ⊢ true : bool
$$
"bajo cualquier contexto Gamma, el tipo es *bool*"

---

## Teorema de Unicidad de tipos-related

Cuando se hace algo del estilo 

```haskell
(\x -> x x) flip 
```

Esto **no** va a tipar, ya que no es posible hacer `\x -> x x` porque sería como aplicar `id id`, donde $id_2$ :: `a -> a`e $id_1$ :: `(a -> a) -> a -> a`.

```haskell

ghci> :t (\x -> x x) flip  
  
<interactive>:1:10: error:  
   • Couldn't match type ‘c’ with ‘a -> c’  
     Expected: a -> b -> c  
       Actual: (a -> b -> c) -> b -> a -> c  
     ‘c’ is a rigid type variable bound by  
       the inferred type of it :: b -> a -> c  
       at <interactive>:1:1  
   • In the first argument of ‘x’, namely ‘x’  
     In the expression: x x  
     In the expression: \ x -> x x  
   • Relevant bindings include  
       x :: (a -> b -> c) -> b -> a -> c (bound at <interactive>:1:3)
```

---

# Cálculo-λᵇ: semántica operacional

Cuando se tiene algo del estilo

$$M \rightarrow N$$

La → solo reduce un programa a *otro* que **aún** no terminó. la flecha no reduce un programa a un valor, nunca.

Ver detenidamente el caso del E-IF. No nos alcanza con tener solo E-ifTrue y E-ifFalse. Podríamos tener alguna entrada más *compleja*, como otro if.

$$\begin{gather} {M → M'} \\ \overline{\text{if} \ M \ \text{then} \ N \ \text{else} \ P → \text{if} \ M' \ \text{then} \ N \ \text{else} \ P} \end{gather}$$

## E-appAbs

En este caso lo que se hace es, en el caso $M$, se reemplaza la $x$ por $V$, eso es lo que significa $M \{ x := V \}$. $V$ es un valor.

Si se tiene algo del estilo
$$M \{ x := N \}$$
significa que se reemplazan las ocurrencias libres de $x$ en $M$ por $N$, evitando la captura de variables.

Se define por recursión ~~estrucutral~~ en M:

```haskell
1. M = x				   x{x := N} = N              {por def}
2. M = y != x			y{x := N} = y              {por def}
3. M = true				true{x := N} = true        {por def}
4. M = false			false{x := N} = false      {por def}
5. M = if M_1 then M_2 else M_3	 
   (if M_1 then M_2 else M_3){x := N}           {por def}
   if M_1 {x := N} then M_2 {x := N} else M_3   {x := N}
6. M = M_1 M_2 (APP)
   M_1 M_2{x := N}                              {por def}
   M_1{x := N} M_2{x := N} 

7. M = λy:τ. M'
   
   (λy:τ, M'){x := N}                           {por def}
				=       hay varios casos

   - si x = y                    => λy:τ. M'
   - si x != y && fv(N) = none   => λy:τ. (M' {x := N})
	   -> esto no estaría bien si fv(N) != none porque estaría metiendo algo     ligado adentro de un λy:τ
      - si x != && && fv(N) =! none => λz:τ. M'{y := z}{x := N}, donde z está       elegida de tal modo que z no está contenida en fv(y)
							         z no está contenida en fv(M')
							         z no está contenida en fv(x)
							         z no está contenida en fv(N)
```