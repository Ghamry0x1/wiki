# Algorithms -- Intro
## Summary
Prologue: about history and complexity

## Content

### Books and algorithms
 The key development of human history is typography, or *algorithms*?

The term, algorithm, is used to honor the man who set up the decimal arithmetic system, which revolutionize the way people think about problems.

### An exponential algorithm -- Fibonacci's  sequence

    function fib(n){
        if(n=0) return 0;
        if(n=1) return 1;
        return fib(n-1)+fib(n-2);
    }

Consider about the time it used, like that:

$T(n)=T(n-1)+T(n-2)+3 for n>1$

Which is no doubt exponential like the Fibonacci sequence itself.

### Optimization of the code above
We can see that during the recursive process, a lot of steps have been repeated. But if we use some *space* to save *time*, we will get a **polynomial** solution:

    function fib2(n){
    if(n=0) return 0;
    int f[0...n];
    f[0]=0; f[1]=1;
    for i = 2..n:
        f[i]=f[i-1]+f[i-2];
    return f[n];
    }

### Complexity
Due to the possible theoretical difficulties, we need to seek an uncluttered, machine-independent chracterization of an algorithm's efficiency. So we consider *the basic steps taken with n input size*.

We express the simplification like $5n^3+4n+3=O(n^3)$ .

There is a order of domination:
exponential  > polymial > logarithm
