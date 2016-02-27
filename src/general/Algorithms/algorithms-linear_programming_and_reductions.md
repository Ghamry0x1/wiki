# Algorithms -- Linear Programming and reductions
Linear programming describes a broad class of optimization tasks in which both the constraints and the optimization criterion are linear functions. It turns out an enormous number of problems can be expressed in this way.

## Intro
It is a general rule that the optimum is achieved at a vertex of the feasible region. So we can use **simplex** algorithm to deal with it:

Move from vertex to vertex, along edges of the polyhedron, maximizing/minimizing your object.

### Solve the real problem
1. Define your variables
2. Give constraints
3. Give object function

## Reductions
If any subroutine for task Q can also be used to solve P, we say P reduces to Q. Like LIS problem can reduce to longest path problem in a DAG.

### Standard from
For any LP optimization problem, maximization or minimization, with both inequalities and equations, and with both nonnegative and unrestricted variables, we can convert or reduce them in to **standard form** in which the variables are all nonnegative, the constraints are all equations, and the objective function is to be minimized.

## Flow in networks
### Maximizing flow
The networks we are dealing with consist of a directed graph G; two special nodes s, t \in V. which are, respectively, a source and sink of G; and capacities c_{e} > 0 on the edges.

The constraints are straight-forward:

1. all flows must not violate capacities
2. For any internal nodes, the flow into/out of it must conserve.

So we actually reduce the maximizing flow problem into LP problem.

### Another method
In fact, if we take a close look at LP algorithm, we can come up with a new algorithm to deal with max-flow problem:

Every iteration, we find a s->t path with edges fulfill such conditions: 

1. (u,v) is in the original network still not at full capacity.
2. The reverse edge (v,u) is in the original network with some flow along it.

And we can capture the flow-increasing opportunity in a *residual network*, which exactly has two types of edges with capacity c^f:
 
* c_{uv}-f_{uv}
* f_{vu}

### Cut
Max-flow min-cut theorem
The size of the maximum flow in a network equals the capacity of the smallest (s,t) cut.

### Bipartite matching
Create source and sink, assign capacities to edges, then search for max flow.

## Duality 
In networks, flows are smaller than cuts, but the max-flow and min-cut exactly coincide and each is therefore a certificate for of the other's optimality.

In LP problem, for constraints which are all "less than constants", we can set some *multiplier* and express object function in multipliers, than we can transform the equation into its *dual* in which constraints are "more than constants" 

By design, any feasible value of this dual LP is an upper bound on the original primal LP. So if we somehow find a pair of primal and dual feasible values than are equal, then the must both be optimal.

*Duality Theorem*: If a LP has a bounded optimum, then so does its dual, and the two optimum values coincide.

## Zero-Sum games
We can present various conflict situations in life by matrix games.

For rock-paper-scissor game, we want to maximize the expected payoff so we choose randomly strategy. We will find the the total payoff is zero.

Well, in symmetrical condition, if Column has to announce his strategy first, his best bet is to choose the mixed strategy y that minimize his loss under Row's best response. And these two LPs are dual to each other.

## The Simplex Algorithm

    let b be any vertex of the feasible region;
    while there is a neighbor v' of v with better objective value:
        set v = v'

What do the concepts of vertex and neighbor mean in this general context?

 *Pick a subset of the inequalities. If there is a unique point that satisfies them with equality, and this point happens to be feasible, then it is a vertex.*

*Two vertices are neighbors if they have n-1 defining inequalities in common.*

### The algorithm
There are two tasks on each iteration:

1. Check whether the current vertex is optimal
2. Determine where to move next

If the current vertex is origin, both tasks will be easy to resolve. 

The task one: *The origin is optimal iff. all c_{i} \leq 0*

The task two: * keep move by increasing some x_{i} for which c_{i} > 0 , until we hit some other constraint.

What if we move to somewhere else? Adjust the coordinate. 

### Circuit Evaluation
For a Boolean Circuit, that is, a DAG of gates of 

* Input gates with zero in-degree and value true or false
* AND gate and OR gate with 2 in-degree
* NOT gate with 1 in-degree
 