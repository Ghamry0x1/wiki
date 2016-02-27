# Algorithms -- Greedy algorithms

## Minimum spanning trees
Here are some property:

1. Removing a cycle edge cannot disconnect a graph
2. A tree on n nodes has n-1 edges
3. Any connected, undirected graph with |E| = |V| -1 is a tree
4. An undirected graph is a tree iff. there is a unique path between any pair of edges

And *cut property*: Suppose edges X are part of a MST of G=(V,E). Pick any subset of nodes S for which X does not cross between S and V-S, and let *e* be the lightest edge across this partition. Then X \cup {e} is part of some MST

### Kruskal's MST algorithm

    procedure kruskal(G, w){
    // Input: A connected graph with weights w
    // Output: A MST defined by edges X
    for all u \in V:
        makeset(u);
    
    X={};
    sort the Edges E by weight;
    for all edges (u,v) \in E. in increasing order of weight:
        if find(u) != find(v):
            add edge (u,v) to X;
            union(u,v)
}


So we need a kind of data structure to support such operations. It is *disjoint sets*

    procedure makeset(x){
        pa[x] = x;
        rank[x] = 0;
    }
    
    function find(x){
        while x != pa[x]:
            x = pa[x];

        return x;

    procedure union(x,y){
        rx = find(x)
        ry = find(y)
        if rx == ry: return
        if rank[rx] > rank[ry]:
            pa[ry] = rx;
        else:
            pa[rx] = ry;
            if rank[rx] = rank[ry]:
                rank[ry] = rank[ry] +1;

### Path Compression

    function find(x):
        if x != pa[x]:
            pa[x] = find(pa[x])
        return pa[x]

### Prim's algorithm
    
    x ={ }
    repeat until |X| = |V| - 1:
        pick a set S \subset V for which X has no edges between S and V-S
        let e \in E be the minimum-weight edge between S and V-S
        X = X \cup {e}

## Huffman encoding
The goal is find a method to encode the message as compressive as possible. And in fact here is 

    cost of tree = \sum_{1}^{n} f[i] * (depth of ith symbol in tree)

And we can also express the sum as *frequencies of all leaves and internal nodes, except the root*

So we can construct the whole tree *from bottom by combining two nodes which are least frequent*

    procedure Huffman(f){
    // Input: An array f[1..n] of frequencies
    // Output: An encoding tree with n leaves
        
    let H be a priority queue of integers, ordered by f
    for i = 1 .. n: insert(H,i)
    for k = n+1 .. 2n-1:
        i = deletemin(H), j = deletemin(H)
        create a node numbered k with children i,j
        f[k] = f[i] + f[j] 
        insert(H,k)

## Horn formulas
This topic is actually about logic. But how we test a satisfying assignment is related to Greedy Method.

## Set Cover
This is about **approximation factor** i.e. even greedy method doesn't behave well, but we'd like to know how far is it from 

    
    
