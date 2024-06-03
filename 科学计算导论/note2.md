### Random Numbers
`v=rand` random value in [0,1]  
`rand(n)` an n x n matrix with random values
`rand(r,c)` an r x c matrix with random values
`X = rand(s,___)`  s: randstreams
### Root Finding
`x = fzero(fun,x_0)`
fun: function to be solved
x0: initial guess at solution
x: solution

Function can be specified as
- a mathematical expression as a string with no predefined variables
- function handle
- name of an anonymous function 
### sort
#### 1D
`[y,I] = sort(x)`
x = input
y = sorted array
I = permutation index
#### 2D
`y = sort(x,dim,mode)`
dim: selects a dimension along which to sort
mode: `'ascend'`,`'descend'`
## Vocabulary
- combinatorial 组合的