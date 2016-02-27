# Chapter 5: Efficient Compilation of Pattern-Matching

Example:

```
mappairs f [] ys         = []
mappairs f (x:xs) []     = []
mappairs f (x:xs) (y:ys) = f x y : mappairs f xs ys
```

The trivial compilation could check 5 times in total -- for the last case. But we can compile it into a more efficient version with `case`.

```
mappairs f xs ys =
    case xs of
        NIL => NIL
        CONS x xs =>
            case ys of
                NIL => NIL
                CONS y ys => CONS (f x y) (mappairs f xs ys)
```

We will study the algorithm which can transform the pattern-matching to case syntax.

First, let's define the `match` syntax, which can be transformed to trivially from pattern matching syntax for function definition.

$$
\begin{split}
match \,
    & [u_1, ..., u_n] \\
    & [( [p_{1,1}, ..., p_{1,n}], E_1), \\
    & \,  ... , \\ 
    & \, ( [p_{m,1}, ..., p_{m,n}], E_m)] \\
    & E
\end{split}
$$

## The Variable Rule
$$
\begin{split}
match \,
    & (u:us) \\
    & [((v_1 : ps_1), E_1), \\
    & \,  ... , \\ 
    & \, ((v_n : ps_n), E_m)] \\
    & E
\end{split}
$$

can be simplified to

$$
\begin{split}
match \,
    & us \\
    & [( ps_1, E_1[u/v_1]), \\
    & \,  ... , \\ 
    & \, ( ps_n, E_m[u/v_n])] \\
    & E
\end{split}
$$


## The Constructor Rule
$$
\begin{split}
match \,
    & (u:us) \\
    & [(((ci \, ps'_{i, 1}) : ps_{i, 1}), E_{i, 1}), \\
    & \,  ... , \\ 
    & \, (((c_i \, ps'_{i, m_i}) : ps_{i, m_i}), E_{i, m_i})] \\
    & E
\end{split}
$$

can be simplified to

$$
\begin{split}
\text{case }u\text{ of }
    & c_1 us'_1 \Rightarrow match \, (us' \texttt{ ++ } us) \, qs'_1 \, E \\
    & ... \\
    & c_k us'_k \Rightarrow match \, (us'_k \texttt{ ++ } us) \, qs'_k \, E
\end{split}
$$

in which each $qs'_i$ if of form
$$ [((ps'_{i, 1} \texttt{ ++ } ps_{i, 1}), E_{i,1}) \\ 
    ..., \\
    ((ps'_{i, m_i} \texttt{ ++ } ps_{i, m_i}), E_{i,m_i})]$$


## The Empty Rule

$$
\begin{split}
match \,
    & [] \\
    & [([], E_1), \\
    & \,  ... , \\ 
    & \, ([], E_m)] \\
    & E
\end{split}
$$

is reduced to $E_1 \| E_2 \| ... \| E_m \| E$, which is $E_1$ if $m > 0$ and is $E$ otherwise.


## The Mixture Rule
When the first pattern is *mixed*, i.e., composed of both variable and constructor, we can't use the above rules. Instead, we may use nested match to decompose the original match's branches, and then transform each single-branch match into a `case` expression. However, that could produce redundant computation due to the nested `case` might involve same variable. Thus, we need a way to optimize it.

## The Pattern-Matching Compiler
> I shall read through the text and blind-implement it in Haskell.

See my gist.github.com

## Optimization
Suppose that `FAIL` is returned by an expression `e`, then one of the following conditions must hold

1. `FAIL` is mentioned explicitly in `e`
2. `E` contains a pattern-matching lambda abstraction whose application may fail
3. `FAIL` is the value of one of the free variables of `e`


After compilation, case 2 doesn't exist. And programmer can't write `FAIL` explicitly, so case 3 can't hold as well.

So we focus on case 1, i.e., on all the places where `FAIL` can be introduces explicitly by the compiler.

### Rules for transforming $\|$ and $FAIL$

* if $E_1$ can't return $FAIL$, then $E_1 \| E_2 \equiv E_1$
* $E \| FAIL \equiv E$
* $FAIL \| E \equiv E$
* $(IF \, E_1 \, E_2 \, E_3) \| E \equiv IF \, E_1 \, E_2 \, (E_3 \| E)$

### Eliminating $\|$ and $FAIL$

Transform the pairs of guard and alternative into nested `IF` and finalized the innermost $else$ with either $FAIL$ or default case provided by $otherwise$.

However, we can also do some tricks in the process of compilation to machine code.

## Uniform equations
Sometimes, the order in which we write clauses of matching in function definition might effect the determinism property.

For example:

```
diagonal x      True    False = 1 -- (1)
diagonal False  y       True  = 2 -- (2)
diagonal True   False   z     = 3 -- (3)
```

If we evaluate $diagonal bottom True False$, then the above order will be `1`, but if we interchange `(1)` with `(3)`, then it will not terminate.

### Definition of "Uniformity"
1. All equations begin with a variable pattern, and applying the variable rule yields a new set of uniform equations
2. Or, all equations begin with a constructor pattern, and applying the constructor rule yields a new set of uniform equations
3. Or, all equations have an empty list of pattern, and the empty rule applies and there is at most one equations in the set

### Properties of "Uniformity"
If a definition is uniform, *changing the order* of the equations does not change the meaning of the definition. And vice versa.








 
