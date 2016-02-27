# Purely Functional Data Structure -- Intro

Both strict and lazy evaluations have implications for the design and analysis of data structure. Strict languages can describe worst-case data structures, but not amortized ones, while for lazy it is the contrary case.

\$-notation - to suspend the evaluation of some expression e, we write \$e.

The scope of \$ operator extends as far to the right as possible, e.g., \$ f x is parsed as $(f x).

Except for explicit `force` operator, pattern matching against a \$x will also force it.

A example code:

```
fun take(n, s) = $case (n, s) of
     (0, _) => Nil
    |(_, $Nil) => Nil
    |(_, $Cons(x, s')) => Cons(x, take (n - 1, s')) 
```

## Amortized Bound
First we define the amortized cost of each operation and then proves that, for any sequence of operations, the total amortized cost of the operations is an upper bound on the total actual cost.

$$\sum_{i = 1}^m a_i \geq \sum_{i = 1}^m t_i$$

There are two techniques by Tarjan for analyzing ephemeral amortized data structures: the banker's method and the physicist's method.

In the banker’s method, the accumulated savings are represented as credits that are associated with individual locations in the data structure. These credits are used to pay for future accesses to these locations. The amortized cost of any operation is defined to be the actual cost of the operation plus the credits allocated by the operation minus the credits spent by the operation, i.e., $$a_i = t_i + c_i - \bar c_i$$

Proofs using the banker’s method typically define a credit invariant that regulates the distribution of credits in such a way that, whenever an expensive operation might occur, sufficient credits have been allocated in the right locations to cover its cost.

In the physicist’s method, one describes a function $\Phi$ that maps each object $d$ to a real number called the *potential* of $d$. The function $\Phi$  is typically chosen so that the potential is initially zero and is always non-negative. Then, the potential represents a lower bound on the accumulated savings.

Let $d_i$ be the output of operation $i$ and the input of operation $i + 1$. Then, the amortized cost of operation $i$ is defined to be the actual cost plus the change in potential between $d_i$   and $d_{i + 1}$ , i.e., $$a_i = t_i + \Phi(d_i) - \Phi(d_{i - 1})$$And the two methods are inter-convertible.


## Queue's Implementation
Functional `queue` is usually implemented with two `list`.

```
datatype Queue = Queue of { F: a list, R: a list }

fun snoc (Queue {F = [], ...}, x)       = Queue {F = [x], R = []}       (* worst: O(1) *)
   |snoc (Queue {F = f , R = r}, x )    = Queue {F = f  , R = x :: r }  (* worst: O(1) *)fun tail (Queue {F = [x], R = r})       = Queue {F = rev r , R = []}    (* worst: O(n) *)
   |tail (Queue {F = x :: f , R = r})   = Queue {F = f , R = r}         (* worst: O(1) *)
```


Credit invariant: Credit = length of queue

Potential function: length of rear list.


## Persistence: The Problem of Multiple Futures
Inherent weakness of any accounting system based on accumulated savings -- the savings can only be spent once. It works well in ephemeral (singly-threaded) setting, will fail with persistence, in which an operation might have multiple logical futures, each competing to spend the same savings.

Execution Traces: The logical history of operation $v$ , denoted $\hat v$, is the set of all operations on which the result of $v$ depends (including $v$ itself). In other words, $v$ is the set of all nodes $w$ such that there exists a path (possibly of length 0) from $w$ to $v$. A logical future of a node $v$ is any path from $v$ to a terminal node (i.e., a node with out-degree zero).

## Debt: amortization for persistence
The intuition is that, although savings can only be spent once, it does no harm to pay off debt more than once.> Difference between call-by-name and call-by-need: lazy evaluation without and with memorization.

With call-by-need, the repeated evaluation over "expensive" operation will cost in a linear fashion.

Classifying the cost:

1. *Unshared cost*: Actual time to execute the operation assuming that every suspension in the system at the beginning of the operation has already been forced and memorized.
2. *Shared cost*: The time to execute every suspension created but not evaluated by the operation.
    * *Realized cost*: For suspensions executed during the overall computation
    * *Unrealized cost*: For suspensions never executed
3. *Complete cost*: shared + unshared.
4. *Total actual cost*: unshared + realized shared

For shared costs, we account by *accumulated debt*. Initially, the accumulated debt is zero, but every time a suspension is created, we increase the accumulated debt by the shared cost of the suspension (and any nested suspensions). Each operation then pays off a portion of the accumulated debt. The amortized cost of an operation is the unshared cost of the operation plus the amount of accumulated debt paid off by the operation. We are not allowed to force a suspension until the debt associated with the suspension is entirely paid off.

> This treatment of debt is reminiscent of a layaway plan, in which one reserves an item and then makes regular payments, but receives the item only when it is entirely paid off.


Three important moments in the life cycle of a suspension:

1. When it is created
2. When it is entirely paid off
3. When it is executed

## Banker's Method
Claim: The total amortized cost is an upper bound on the total actual cost.

Defined: The total amortized cost is the total unshared cost plus the total number of debits discharged; The total amortized cost is the total unshared cost plus the realized shared cost.

Thus to prove: **The total number of debits discharged is an upper bound on the realized shared costs**.


Abstraction: Graph labelling problem - label every node in a trace with three (multi-)sets $s(v)$, $a(v)$, $r(v)$ such that

$$v \neq v' \Rightarrow s(v) \cap s(v') = \emptyset \\
  a(v) \subseteq \cup_{w \in \hat v} s(w) \\
  r(v) \subseteq \cup_{w \in \hat v} a(w) $$

$s(v)$ is debits allocated by operation $v$. So no debits maybe allocated more than once. $a(v)$ is the multi-set of debits discharged by $v$. So an operation can only discharge debits that appear in its logical history. $r(v)$ is the multi-set of debits realized by $v$. So no debit may be realized unless it has been discharged within the logical history of the current operation.

> If we combine a single object with itself, we might discharge the same debit more than once.

Let $V$ be the set of all nodes in the execution trace, then the total shared cost is $\sum_{v \in V} | s(v) |$ and the total number of debits discharged is $\sum_{v \in V}|a(v)|$. Because of memorization, the realized shared cost is not $\sum_{v \in V}|r(v)|$ but rather $|\sum_{v \in V}r(v)|$.

Debit invariant: $$D(i) \leq min(2i, |F| - |R|)$$

### Example: Queues

I don't understand what the author is trying to stress here, nor can I analyze and prove the invariant myself. Here are some questions I have in mind now:

1. What does "debit" mean? The relationship with "debt"?
2. What invariant does the method maintain? How to express the amortized cost?


For the first question:

The debit is to credit as debt is to savings. Each debit represents a constant amount of suspended work. Each debit is associated with a location in the object.

For the second question:

* Debits discharged $\geq$ realized shared costs
* Rotate the queue: $|F| \geq |R|$
* Debit invariant: $D(i) \leq min(2i, |F| - |R|)$, in which $d(i)$ is the debit on the $i$-th node of the front stream, and $D(i) = \sum_{j = 0}^id(j)$


Ok, now I understand the invariant a bit. But how about proofs and reasonings?

* When should we rotate the queue?
    + if we rotate the queue when $|R| \approx |F|$ and discharge one debit per operation, then we will have paid for the `reverse` by the time it is executed.
* How this implementation deals efficiently with persistence?
    + The queue is rotated during the first application of `tail`, and the `reverse` suspension created by the rotation is forced during the last application of `tail`. This reversal takes $m$ steps, and its cost is amortized over the sequence $q_1 ... q_m$
* Choose some branch point $k$, and repeat the calculation from $q_k$ to $q_m$(Note that $q_k$ is used persistently.) Do this $d$ times. How often is the `reverse` executed?
     * we duplicate work only when we also duplicate the sequence of operations over which to amortize the cost of that work.

## Physicist's Method
Function $\Psi$ maps each object to a potential representing an upper bound on the accumulated debt.

The major difference between the banker's and physicist's methods:

1. When can we force a shared suspension? As soon as the debits for *that* suspension have been paid off, or until we have reduce the entire accumulated debt for an object to zero.
2. Physicist's method is generally - simpler but weaker.
3. Since physicist's method cannot take advantage of the piecemeal execution of nested suspensions, there is no reason to prefer incremental function to monolithic functions.

```
datatype a Queue = Queue of {
    W: a list,
    F: a list susp,
    LenF: int,
    R: a list,
    LenR: int
}
```

The major functions:

```
fun snoc (Queue { W = w, F = f, LenF = lenF, R = r, LenR = lenR}, x) = 
        queue { W = w, F = f, LenF = lenF, R = x :: r, LenR = lenR + 1}

fun head (Queue {W = x :: w, ...}) = x

fun tail (Queue { W = w, F = f, LenF = lenF, R = r, LenR = lenR }) = 
    queue { W = w, F = $tl (force f), LenF = lenF - 1, R = r, LenR = lenR }
```

We need a $\Psi$ that will be zero whenever we force the suspended list. This happens:

1. $W$ becomes empty
2. $R$ becomes longer than $F$

So $$\Psi(q) = min(2|W|, |F| - |R|)$$


There is a proof over *The amortized costs of `snoc` and `tail` are at most two and four, respectively*. The proof itself is rather, boring. But there is some point:

1. Consider two cases: causing a rotation and not.
2. Consider the source of amortized cost: share cost, change of potential, complete cost et cetera.

So that's it I won't advance further in this chapter for the first time read.






