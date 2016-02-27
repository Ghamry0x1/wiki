# Analysis of Functional Algorithms

Functional programs are evaluated by reducing expressions to values. So different reduction orders are important.

A *reduction strategy* is about choosing next expression to reduce. And proving it terminates, the produced result should be in *normal form*.

call-by-name, or lazy evaluation, is often implemented using a *graph reductio* mechanism:

1. When a function application is reduced, a copy of its body is made with the formal parameters replaced by pointers to the graphs of the respective arguments.
2. When an argument is evaluated, its graph is replaced by its value which is shared.


Strictness analysis: Determine the situations in which it is safe to evaluate an expression strictly because its value is needed in every execution.


> Divergence could be a factor. If an argument can go divergent, then it might not be equivalently strict.

In a lazy language, algebraic type constructors are also lazy. For example, an application `Cons a b` won't evaluate `a` and `b` until needed.

Step-counting analysis: Use the number of function applications as a measure.

### Transformation
1. expression $e$ has a cost $T(e)$
2. function $f$ has a step-counting version $T_f$

`{f a1 a2 ... an = e}` $\Rightarrow$ `{Tf a1 a2 ... an = 1 + T(e)}`

`T(f a1 a2 ... an) = T(a1) + t(a2) + ... + T(an) + (Tf a1 a2 ... an)`

## Program Transformation
The Burstall-Darlington transformation system

* Unfolding
* Constant Evaluation
* Instantiation
* Definition
* Folding
* Abstraction: introduces local definitions

About TCO: In a lazy language, TCO only works if the parameters of the recursive call are strictly evaluated.




## Exercises
### 3.1
* Only `a`: `(f $! a) b`
* Only `b`: `(f a) $! b`
* `a` and `b`: `(f $! a) $! b`

### 3.2
* $T_{power, 0} = 2$
* $T_{power, k} = T_{if} + 1 + T_{if} + 2 + (T_{power, k / 2} + 1)$

It is a tail-call, plus `k 'div' 2`, so space complexity should be $O(log(k))$


### 3.3
a) lazy list: `length` - $O(n)$, `head` - $O(m)$, `sum` - $O(mn)$
<br>b) strict tails: `length` - $O(mn)$, `head` - $O(m)$, `sum` - $O(mn)$
<br>c) all strict: `length` - $O(mn)$, `head` - $O(mn)$, `sum` - $O(mn)$

### 3.4
a)

```haskell
sum 0 ret = ret + 0
sum n ret = sum (n - 1) (ret + n)

prod 0 ret = ret * 1
prod n ret = prod (n - 1) (ret * n)
```

b)

```haskell
prodsum n = x + y where (x, y) = g n

g n = (n * x, n + y) where (x, y) = g (n - 1)
g 0 = (1, 0)
```
c)

$$\begin{split}
prodsum(n) & = n! + \sum^n_{i = 0}i \\
          & = n (n - 1)! + n + \sum^{n - 1}_{i = 0}i \\
          & = n((n - 1)! + \sum^{n - 1}_{i = 0}i) - (n-1)\sum^{ n - 1}_{i = 0}i + n \\
          & = n \cdot prodsum(n - 1) - \frac{n (n - 1) (n - 2)}{2} + \frac{n (n - 1) }{2} \\
\end{split}$$

so 

$$
prodsum(n) - \frac{n (n - 1) }{2} = n(prodsum(n - 1) - \frac{(n - 1)(n - 2)}{2}) \\
g(n) = n g(n - 1) \\
g(1) = prodsum(1) = 2\\
prodsum(n) = g(n) + \frac{n(n-1)}{2}
$$







