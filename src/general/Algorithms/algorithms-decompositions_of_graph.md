# Algorithms -- Decompositions of Graph
## How to express graph
1. Adjacency matrix
2. Adjacency list

 If the number of edges or |E| is close to the upper limit, we call the graph **dense**. On the contrary, if |E| is close to |V| , it is sparse.

So |E| is always the crucial factor when selecting the right algorithm.

## Depth-First Search
### Exploring Mazes
The problem is *what parts of the graph are reachable from a given vertex?*

    procedure explore(G, v){
    // Explore from vertex v in graph G
    visited(v) = true;
    previsit(v);
    for each edge (v, u) in G:
        if not visited(u): explore(G, u);
    postvisit(v);

### What is DFS?

    procedure dfs(G){
    for all v in V:
        visited(v) = false;
    for all v in V:    
        if not visited(v):    
            explore(G, v);
    }

Using DFS, we will get *connected component*

And to define:
    
    procedure previsit(v)
        ccnum[v] =cc 

And cc will increase every time DFS calls explore;

### DAG: Directed acyclic graph
There are some properties:

1. Directed graph has a cycle iff. its DFS reveals a back-edge
2. In DAG, every edge leads to a vertex with a *lower POST number*
3. DAG has at least one source and at least one sink.

How to linearize the DAG?
1. Find a source, output it and delete it
2. Repeat until the graph is empty.

## Strongly Connected Component
First, how to define connectivity?

*Two nodes u and v of a directed graph are connected if there is a path from u to b and a reversed one*

And a more intriguing one:
Every directed graph is a dag of its strongly connected components.

### An efficient algorithm
*Property One*: If the explore subroutine is started at node u, then it will terminate precisely when all nodes reachable from u have been visited.

*Property Two*: The node that receives the highest post number in a DFS must lie in a source strongly connected component.

*Property Three*:  If C and C' are strongly connected components, and there is an edge from a node in C to a node in C', then the highest post number in C is bigger than the highest post number in C'