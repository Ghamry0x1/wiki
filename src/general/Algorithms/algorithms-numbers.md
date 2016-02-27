# Algorithms -- Numbers

## Basic arithmetic
### A basic decimal property:
*The sum of any three single-digit number is at most two digits long*

For expressing number $k$ with base $b$, we need $\lceil log_{b}(N+1) \rceil$ digits.

For binary multiplication, *the left-shifting is just a quick way to multiply by the base.*

There is another multiplying method, code as below:
    
    function multiply(x,y){
    // Input: n-bit integers x and y, where y>=0;
    // Output: the product of them
    if y == 0: return 0;
    z = multiply(x, y/2); // here is the floor of y/2
    if y is even:
        return 2*z;
    else:
        return x+2*z;
    }

And division:

    function divide(x,y){
    // Output: The quotient and remainder of x divided by y
    if x == 0: return (q,r) = (0,0)
    (q,r) = divide( x/2, y );
    q = 2*q; r = 2*r;
    if x is odd: r=r+1
    if r >= y: r = r-y, q = q+1;
    return (q,r);

How to analyze this method?

### Modular Arithmetic
Modular arithmetic is a system for dealing with restricted ranges of integers. 

In fact, this provides a simpler way to think about "two's complement", namely, we use n bits to represent number in the range $[-2^{n-1}, 2{n-1}-1]:

* Positive integers, in the range $[0, 2^{n-1}-1]$, are stored in regular binary with a leading bit of 0;
* Negative integers, such as -x, with x in the range $[1, 2^{n-1}]$, are stored by first constructing x in binary, then flipping all the bits and finally adding 1. Then leading bit in this case is 1.

OK, how to think about it? Any number in the range $[-2^{n-1}, 2{n-1}-1] is stored *modulo 2^n*. 

Modular exponent

    function modexp(x, y, N){
        //Output: x^y(mod N)
        if y == 0: return 1;
        z = modexp(x, y/2, N);
        if y is even: return z^2 mod N;
        else: return x*z^2 mod N;
    }

How to understand this snippet of code? When we do y/2, if y is odd, it's apparent that we will lose during the floor operation. So we multiply it back with x in else statement.

### gcd
Euclid's rule: *if x>=y>0, then gcd(x, y) = gcd (x mod y, y)

A simple extension of Euclid's algorithm

    function ex-Euclid(a,b){
        \\Output: Integers x, y, d s.t. d=gcd(a,b) and ax+by=d
        if b == 0: return (1, 0, a);
        (x', y', d) = ex-Euclid(b, a mod b);
        return (y', x' - a/b*y', d);
    }

### Modular division
We say $x$ is the multiplication inverse of $a$ modulo $N$ iff $ax \equiv 1 (mod N)$

### Primality Testing
Fermat's little theorem: *if p is prime, then* $\forall 1 \leq a < p$, $$a^{p-1} \equiv 1 (mod p) $$

An algorithm for testing primality, with low error probability.

    function primality2(N){
    Pick positive integers a1, a2, ..., ak at random;
    if ai^(N-1) \equiv 1 (mod N) for all i = 1, 2, ..., l: return yes;
    else: return  no;
    }

### Generating random primes
* Pick a random n-bit number N
* Run a primality test on N
* If it passed the test, output it; else repeat the process

### Private-Key Schemes
The function of encoding is invertible, or have a inverse function for decoding.

*One time pad* -- use **exclusive-or** bewteen the message and key, we get cipher-text; And for Bob, he can use another time **exclusive-or** between the cipher-text and key to restore the plain-text.

* AES (Advanced Encryption Standard) * -- can use a constant key which has a fixed size, such as 128 bit, and specify a bijection from same-size string to another same-size string.

### RSA
* Bob chooses his public key adn secret key.
    * He starts picking two large, n-bit random primes p and q
    * His public key is (N,e) where N = pq and e is a 2n-bit number relatively prime to (p-1)(q-1). 
    * Determine d, the inverse of e modulo (p-1)(q-1). And d is secret key
* Alice send message x to Bob
    * She use public key to send him y=(x^e mod N)
    * Bob decodes the message by computing y^d mod N

The security of RSA depends on: *Given N, e, and y=x^e mod N, it is computationally intractable to determine x*

## Hashing
Hashing is a very useful method of storing data items in a table so as to support insertions, deletions and queries.

With hashing, we can almost achieve linear time consumption efficiency with linear space consumption, compared to direct mapping and link table.

The hash function is used to assign the entries to positions on hash table, or assign x to h(x).

Apparently, we need randomization to deal with the unpredictable behaviour of distribution.

So we have: For any two items, the probability these items collide is 1/n if the hash function is randomly drawn from a universal family.
