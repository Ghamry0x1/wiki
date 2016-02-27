# Abstract Interpretation

**Point:** Abstract interpretation of programs is a *unified approach* to apparently unrelated program analysis techniques.


## Syntax
* Program: a set of "nodes".
* Node: has successor and predecessor nodes
    + Entry: no pred, one succ
    + Assignment: one pred, one succ; "Ident" <- "Expr"
    + Test: one pred, two succ; if "Bexpr" then "Expr" else "Expr"
    + Junction: one succ, more than one pred.
    + Exit: one pred, no succ.

## Semantics
* $S_0 = lattice(S \,\cup \{\bot_S, \top_S\}), \forall x \in S, \bot_S \leq x \leq \top_S$
* "Values" semantic domain: a complete lattice as sum of primitive domains
* $Env = Ident^0 \rightarrow Values$
* Meaning of an expression: $val: Expr \rightarrow [Env \rightarrow Values]$, in particular $\underline{val}: Bexpr \rightarrow [Env \rightarrow Bool]$
* $\forall s \in States, s = \langle cs(s), env(s)\rangle$, i.e. control state and environment state
* **???** if $e \in Env, v \in Values, x \in Ident$, then $e [v / x] = \lambda y . \underline{cond}(y = x, v, e(y))$
* $\texttt{n-state }: States \rightarrow States$

And there are a lot of other stuff defined. But in total they look pretty puzzling to me ...

## Static Semantics of Programs
$Cv$ is a static summary of the possible executions of the program.

Before that, a lot of definitions are here. *But I hardly know the motivations for such definitions*.

Quite difficult. I decide to have a glimpse at [MIT course](http://web.mit.edu/16.399/www/#notes) first.

## Note of Notes of MIT Course
Well .. The first slide is a bit puzzling ... I should continue or look at the reading assignments? CONTINUE.


This paper reading will be transformed into course reading of the MIT course.
