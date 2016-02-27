# Chapter 4: Translating Miranda into the enriched lambda calculus

## Pattern Match
* overlapping patterns
* constant patterns
* nested patterns
* multiple arguments
* non-exhaustive sets of equations
* conditional equations
* repeated variables

### Patterns
```
p = v
  | constant
  | constructor p1 ... p2
```

A *pattern-matching lambda abstraction*: $\lambda p . E$, where $p$ is a pattern.

### Failed matching
We introduce a built-in value `FAIL`, which is returned when a pattern-match fails.

The $\parallel$ is an infix function, which:

$$\begin{split}
& a \parallel b = a,\text{ if }a \neq \perp\text{ and }a \neq \texttt{FAIL } \\
& \texttt{FAIL }\parallel b = b \\
& \perp \parallel b = \,\perp
\end{split}$$

For multiple argument matching, we add a reduction rule for `FAIL`

$$\texttt{FAIL }E\rightarrow \texttt{FAIL }$$


`TR` and guards:

$$ \begin{split}
   & A_1, G_1 \\
=\, & A_2, G_2 \\
... \\
=\, & A_n, G_n \\
\end{split}$$

$$
(\texttt{IF } TE[\![G_1]\!]\,TE[\![A_1]\!] \\
(\texttt{IF } TE[\![G_1]\!]\,TE[\![A_1]\!] \\
... \\
(\texttt{IF } TE[\![G_n]\!]\,TE[\![A_n]\!]\texttt{ FAIL})...))
$$

## Strictness
The ordinary product $A \times B = \{(a, b) \,|\, a \in A, b \in B\}$, which has bottom element $(\perp, \perp)$

The lifted product, $(A \times B)_\perp = (A \times B) \cup \{ \perp \}$, which has bottom element $\perp \,\neq (\perp, \perp)$

The insight is that lazy product-matching corresponds to ordinary product, while strict product-matching corresponds to lifted product. To implement the ordinary product domain $(A \times B)$, we have to make $(\perp, \perp)$ indistinguishable from non-termination. 

## Case-expressions
Case-expressions is a construct describing a simple form of pattern-matching which is more efficient.

Two points: *simple* (not nested), *exhaustive* (cover all constructors).



