# Algorithms -- Dynamic Programming
## Shortest path in DAGs
Since DAG can be linearized, we can write the nodes with direction from left to right. So for node D, the shortest path **to D** must go through its predecessors, namely, node B and C. So we have:

    dist(D) = min{ dist(B) + l(B, D), dist(C)+l(B, C) );

If we apply this step from source to end, we will get a *Dynamic Programming Method*.

## DP
In dynamic programming, we solve a problem by identifying a collection of subproblems and tackling them one by one, smaller first, using the answers to small problems to help figure out larger ones.

The DAG is *implicit* since its nodes are sub-problems we define, and its edges are the dependencies between sub-problems.

## Longest increasing subsequences
The arrow, or directed edge donate transitions between consecutive elements of the optimal solution. Then we construct our solution space for LIS problem into a DAG. And our goal is to find the longest path in the DAG!

    for j = 1 .. n:
        L(j) = 1 + max{ L(i): (i,j) \in E }
    return max{ L(j) with j = 1..n}

In this example, how to record our solution? Store and update prev(j) every time we iterate, and backtrack to recover the path we want.

## Edit distance
The problem is like that: given two strings, find the minimum edit distance between those two strings. And the definition of *edit distance* is for one situation of alignment, for each corresponding position, if the two character on this position is different, we will add edit distance by one.

The subproblem is for shorter section of both strings, namely A[1..i] and B[1..j] where i<=strlen(A) and j<=strlen(B)

    for i = 0 .. strlen(A)-1:
        E(i, 0) = i;
    for j = 0 .. strlen(B)-1:
        E(0, j) = j;
    for i = 1 .. strlen(A)-1:
        for j = 1 .. strlen(B) -1:
            E(i,j) = min{ 	};
    return E(m,n)

### *Some Common forms for DP*
1. Sub-problem(s) is the prefix of problem(s)
2. Sub-problem is the infix of problem
3. Sub-problem is the sub-tree of problem

## Knapsack 
There are two kind of knapsack problems, one with repetition and another without repetition. The core difference with DP is the dimension of solution space or state-function. Anyway, here is code

    // With repetition
    // K(w) = maximum value achievable with a knapsack of capacity w
    K(0) = 0;
    for w = 1 ... W:    
        K(w)  = max{ K(w - w[i]) + v[i] : w[i] <= w }
    return K(W);

    // Without repetition
    // K(w,j) = maximum value achievable using a knapsack w and items 1 ... j
    Initialize all K(0, j) = 0 and all K(w, 0) = 0;
    for j = 1 .. n:
        for w = 1 .. W:
            if w[j] > w: K(w,j) = K(w,j-1)
            else:    
                K(w,j) = max{ K(w, j-1), K(w-w[i], j-1)+v[i] };
    return K(W,n);

  ## Chain matrix multiplication
Since the multiplication of matrix is associative, we can combine the order of multiplication as we want. And the cost should be the steps for every multiplication. We can construct a binary tree to symbolize the actual order of multiplication. And the cost is the internal and root nodes' multiplication cost. 

For a internal node, if it is the root, the cost of whole problem will be the sub-cost plus the cost happening in this node. So we have code:

    //C(i, j) = minimum cost of multiplying A[i] * ... * A[j]
    for i = 1 .. n: C(i, j) = 0;
    for s =1 .. n-1: // s donates the size of sub-problem
        for i = 1 .. n-s:
            j = i+s;
            C(i,j) = min{ C(i, k) + C(k+1, j) + m[i-1]*m[k]*m[j]: i<=k<j };
    return C(1,n);

## Shortest path with Floyd Algorithm

    // dist(i, j, k) = the length of the shortest path from i to j in which only nodes {1 .. k} can be intermediates.
    for i = 1 .. n:
        for j = 1.. n:
            dist(i, j, 0) = \infty;
    for all (i ,j) \in E:
        dist(i, j, 0) = l(i, j)
    for k = 1 .. n:
        for i = 1 .. n:
            for j = 1 .. n:
                dist(i, j, k) = min{ dist(i, k, k-1)+dist(k, j, k-1), dist(i, j, k-1) }

# The traveling salesman problem
As we all know, the goal is to design a tour that starts and ends at 1, includes all other cities exactly once with minimum total length.

Although here is a bad news that TSP doesn't have a polynomial time, we can use DP to tackle it. Here is a subproblem:

*For a subset of S \subseteq {1, 2, .., n} that includes 1, and j \in S, let C(S, j) be the length of the shortest path visiting each node in S exactly once, starting at 1 and ending at j.*

Here is the code:

    C({ 1 }, 1) = 0;
    for s = 2 .. n:
        for all S \subseteq {1 .. n} of size s and containing 1:
            C(S, 1) = \infty
            for all j \in S, j \neq 1:
                C(s, j) = min{ C(S - { j }, i) + d[i][j] };
    return min{ C({1 .. n}, j : j = 2 .. n) + d[minj][i]

## Largest independent set
A subset of nodes S \subset V is an independent set of graph G, if there is no edges between them.

Another NPC problem, but we can assume one condition: the G can be seen as a tree.

Sub-problem: I(u) = size of largest independent set of subtree hanging from u

And our goal is I(r) with r is the root of any possible tree as defined.

so I(u) = max{ 1 + \sum_{grandchildren w of u} I(w), \sum_{children w of i} I(w) }

  
