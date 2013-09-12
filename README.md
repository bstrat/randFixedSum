randFixedSum
============

Vectors with Fixed Sum - A port of the [MATLAB function randfixedsum](http://www.mathworks.com/matlabcentral/fileexchange/9700-random-vectors-with-fixed-sum) by Roger Stafford to javascript.

The function call `randFixedSum(n,m,s,a,b)` returns an array of `m` arrays, each having `n` random elements between
`a` and `b` which sum up to `s`.
For example, the following command writes `10` CSV rows to `stdout`, each having `3` columns with values between `0` and `1` which sum up to `1.25` (for this to work you need to have [CoffeeScript](http://coffescript.org) running on [Node.js](http://nodejs.org)):

    coffee -e "require './randfixedsum.coffee'; console.log r.join ',' for r in randFixedSum 3,10,1.25,0,1"
