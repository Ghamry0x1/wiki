# Type Systems
> Luca Cardelli

**The fundamental purpose** of a type system is to prevent the *occurrence of execution errors* during the running of a program.

issue 0: what constitutes an execution error?

issue 1: How to prove its absence?

## Definitions
* Execution errors: occurrence of an unexpected software fault, such as illegal instruction, illegal memory reference, divide by zero, dereferencing `nil` et cetera.
    + Trapped: Cause program to exit instantly
    + Untrapped: Reading garbage value from some address
* Typed languages: variable's value are ranged.
* Untyped languages: no types or single type for all
* Safe languages: one does not cause untrapped errors. Untyped can also be safe with runtime check; Typed language might be a mixture of runtime check and static check.

      | Typed  | Untyped
------|--------|--------
**Safe**  |ML, Java|LISP
**Unsafe**|C       |Assembly

### Trade-off
Typing can improve security & execution speed, reduce maintenance cost, but maybe reduce development flexibility, and cost extra time for compilation

### Type Equivalence
Structural versus Nominal

## Language of type systems
Type systems, or the rules, can be decoupled from specific type-checking algorithm.

Judgement: $\Gamma \vdash \mathfrak J$, $\mathfrak J$ is an assertion, in which the free variables are declared in $\Gamma$.

Typing judgement: $\Gamma \vdash M : A$, $M$ has type $A$ in $\Gamma$.

Well formed: $\Gamma \vdash \diamond$

Type rule: $$\frac{\Gamma_1 \vdash \mathfrak J_1, ..., \Gamma_n \vdash \mathfrak J_n}{\Gamma \vdash \mathfrak J}$$

Type derivations: A tree of judgements.

Type inference: Find the type derivation which leads to some typing judgement.

Type construction: Constructive rule about type itself, usually in form of $\Gamma \Vdash T$

## First-order Type Systems
No type param and type abstraction, but with higher order functions.

The most interesting construct introduced in the paper is *Recursive Type*.

First, environments are extended to include type variables $X$. So we can write type in form of $\mu X.A$.

Second, the operations *fold* and *unfold* are explicit **coercions** that map between a recursive type $\mu X.A$ and its unfolding $[\mu X.A/X]A$, and vice versa. They obey laws of $unfold(fold(M)) = M$ and $fold(unfold(M)) = M$.

Here gives the construction of recursive types:

$$\frac{\Gamma, X \Vdash A}{\Gamma \Vdash \mu X.A}\text{TypeRec}$$

$$\frac{\Gamma \vdash M:[\mu X.A/X]A}{\Gamma \vdash fold_{\mu X.A}M:\mu X.A}\text{ValFold}$$

$$\frac{\Gamma \vdash M: \mu X.A}{\Gamma \vdash unfold_{\mu X.A}M:[\mu X.A/X]A}\text{ValUnfold}$$

> Note: I found that the subscript $\mu X.A$ is just a indicator -- we shouldn't need to write it in code or infer anything about it

Let's apply it to construct a $List$ type.

$$List_A \triangleq \mu X.(Unit + (A \times X))$$

$$nil_A : List_A \triangleq fold(inLeft \, unit)$$

$$cons_A:A \rightarrow List_A \rightarrow List_A \triangleq \lambda \, hd : A.\lambda \, tl : List_A . fold(inRight \langle hd, tl \rangle)$$

$$listCase_{A,B} : List_A \rightarrow B \rightarrow (A \times List_A \rightarrow B) \rightarrow B
\\ \triangleq \\
\lambda \,l:List_A.\lambda\,n:B.\lambda\,c:A\times List_A \rightarrow B. \\
\begin{split}
\text{case }(unfold \, l)\text{ of}
  &\, unit:Unit\text{ then }n \\
| &\, p:A\times List_A\text{ then }c \, p
\end{split}
$$

Encoding of divergence and y combinator via recursive types:

$$\bot_A:A \triangleq (\lambda x:B.(unfold_B\, x)\,x)\,(fold_B(\lambda x:B.(unfold_B \, x) \, x))$$

> Remember that "divergence" is something can't be evaluated to the normal form but instead reduced back to the original form.

$$Y_A:(A \rightarrow A) \rightarrow A \triangleq \\ \lambda f: A \rightarrow A.(\lambda x:B.f((unfold_B\,x)\,x))\,(fold_B(\lambda x:B.f((unfold_B\,x)\,x)))$$

Some induction:

$$B \sim \mu X.A \\
f((unfold_B\,x)\,x):A 
$$


Encoding the Untyped λ-calculus via recursive types

$$V \triangleq \mu X.X\rightarrow X \\
[[x]] \triangleq x \\
[[\lambda x.M]] \triangleq fold_V(\lambda x:V.[[M]]) \\
[[M\,N]] \triangleq (unfold_V[[M]])[[N]]$$

## Second-Order Type Systems
Just the old-style parametric polymorphism.

Let's see how existential types are introduced.

$$\frac{\Gamma, X \vdash A}{\Gamma \vdash \exists X.A}\text{TypeExists}$$

$$\frac{\Gamma \vdash [B/X]M:[B/X]A}{\Gamma \vdash (pack_{\exists X.A}X=B\text{ with }M):\exists X.A}\text{ValPack}$$

$$\frac{\Gamma \vdash M:\exists X.A \quad \Gamma, X, x:A \vdash N:B \quad \Gamma \vdash B}{\Gamma \vdash (open_B \, M\text{ as } X, x:A\text{ in }N) : B}$$

We use it to implement a boolean interface:

```
BoolInterface = exists Bool . {
    true: Bool,
    false: Bool,
    cond: forall Y. Bool -> Y -> Y -> Y
}
```

This interface declares that there exists a type `Bool` (without revealing its identity) that supports the operations `true`, `false` and `cond` of appropriate types.

Now we define an implementation: Use $Unit + Unit$ to represent $Bool$.

```
boolModule : BoolInterface =
    pack BoolInterface Bool = Unit + Unit
    with {
        true  = inLeft(unit),
        false = inRight(unit)
        cond  = \\Y -> \x:Bool -> \y1:Y -> \y2:Y ->
                    case Y x of
                        x1:Unit -> y_1
                        x2:Unit -> y_2
    }
```

Finally, a client could make use of this module by opening it, and thus getting access to an abstract name $Bool$ for the boolean type, and a name $boolOp$ for the record of boolean operations.

```
open Nat boolModule as Bool, boolOp {
    true:  Bool,
    false: Bool,
    cond:  forall Y. Bool -> Y -> Y -> Y
} in
    boolOp.cond Nat boolOp.true 1 0
```
