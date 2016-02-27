# Algorithms -- Divide & Conquer

## How does D&C method solve a problem?
1. Break it into sub-problem which is similar to the original question
2. Recursively solving the problem
3. Combining the sub-answers

* At the very tail of the recursion, the sub-problem is so small that it is solved outright.

# A D&C method applied to integer multiplication

    function multiply(x,y){
    if n == 1: return x,y;
    
    xLeft, xRight = leftmost (n/2+1), rightmost(n/2) bits of x;
    yLeft, yRight = leftmost (n/2+1), rightmost(n/2) bits of y;
    
    p1 = multiply(xLeft, yLeft);
    p2 = multiply(xRight, yRight);
    p3 = multiply(xLeft+xRight, yLeft+yRight);
    
    return p1*2^(2*(n/2)) + (p3-p1-p2)*2^(n/2) + p2;
    }

With this Gauss's trick, the time consumption has changed exponentially. Originally, the branching factor would be 4. But with Gauss's trick, the factor can be reduced to three. So after analysis, we can say that the running time would be *O(n^1.59)*.

Impressive.

But based on the Fast Fourier Transform, we can do better .

### Master Theorem
There are about three parameters in Master Theorem which gives a uniform form of recursive algorithm's efficiency.

1. How many sub-problems are here?
2. What is the relationship between the original size and s-b-problem size? 
3. What is the cost of merging the sub-answers.

### Binary search
To find a key in a sorted list, we compare key with the middle element. Depending on the result, we compare key with the left middle or right middle.

### Merge Sort
Recursive version:

    function mergesort( a[1...n] ){
    if n>1: return merge( mergesort( a[1 .. n/2]) + mergesort( a[n/2+1 .. n]) );
    else: return a;
    }
    
    function merge( x[1 .. k], y[1 .. l] ){
    if k==0: return y;
    if l==0: return x;
    if x[1] <= y[1]:
        return cat( x[1], merge( x[2 .. k], y[1 .. l]) );
    else:
        return cat( y[1], merge( x[1 .. k], y[2 .. l]) );
    }

Iterative:

    function interative-mergesort( a[1 .. n]){
        Q = [ ] //empty queue
        for i = 1 .. n:
            push( Q, a[i] );
        while |Q| > 1: // Merge till |Q|=1
            push( Q, merge( pop(Q), pop(Q));
        return pop(Q);
    
### Median
We use D&C method to deal with this problem, let's see a more general one: give the kth biggest element in ordered list S
 
    selection(S, k)  = selection(S_left, k), if k<=|S_left|
                                    selection(S_right, k-|S_left|-|S_right|), if k>|S_left|+|S_right|
                                    v, if otherwise

The tricky part is how to pick the value v? *Randomize*.

### Matrix Multiplication
Another tricky example of how to eliminate the number of branching factor. And this method also use D&C method since it divide the matrix into sub-matrix.

