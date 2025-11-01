# Programación lógica

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

---