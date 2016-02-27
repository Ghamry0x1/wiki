# Algorithms -- Paths in graphs

## Distances
*The distance between two nodes is the length of the shortest path them*

### BFS -- Breadth First Search 
Different from DFS, the BFS aims at the **shortest path** which can be backward constructed if we record the prev node. 

    procedure bfs(G,s){
    // Input: Graph G = (V, E), directed or undirected; From vertex s in V
    // Output: For all vertices u reachable from s, dist(u) is the distance from s to u
    for all u in V: dist(u) = \infty
    
    dist(s) = 0;
    Q = {s};
    while Q is not empty:
         u = pop(Q)
         for all edges (u,v) in E:
             if dist(v) = \infty 
                  push(Q, v);
                  dist(v) = dist(u) + 1;

The queue is FILO

### Dijkstra's Algorithm
Assuming the length or weigh is give on edges. We need to deal with it when we try to figure out the shortest route from the source to specific node.

    procedure dijkstra(G, l, s){
    for all u in V:
        dist(u) = \infty;
        prev(u) = null;
    
    dist(s) = 0;
        
    H = makequeue(V)    \\using dist-values a keys
    while H is not empty:
        H = popMin(H);
        for all edges (u,v) in E:
            if dist(v) > dist(u) + l(u,v):
                dist(v) = dist(u) + l(u,v);
                prev(v) = u;
                decreaseKey(H, v);

However, here is an assumption: There is no negative edge in E

### Priority queue
The priority queue as a data structure should support such operations:

1. Insert
2. getMin
3.  decreaseKey

And there are several implementations:

1. Array (with *sort* method)
2. Binary Heap (it can be realized as an array)
3.  D-ary Heap ( the amount of children is *d* rather than original 2)
4. Fibonacci Heap (a little sophisticated)

### Bellman-Ford Algorithm
For those containing negative edges, we can update *very frequently*

    procedure update( (u,v) in E)
        dist(v) = min( dist(v), dist(u) + l(u,v) );

    procedure bellman-ford(G,l,s){
        for all u in V:
            dist(u) = \infty
            prev(u) = null

        dist(s) = 0;

        repeat |V| -1 times:
            for all e in E:
                update(e)

And actually, for DAG, we can solve the problem in linear time. The difference is that we need to linearize G before updating, and the order of updating is in linearized order.


        

