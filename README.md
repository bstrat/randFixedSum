randFixedSum
============

Vectors with Fixed Sum - A port of the [MATLAB function randfixedsum by Roger Stafford](http://www.mathworks.com/matlabcentral/fileexchange/9700-random-vectors-with-fixed-sum) to javascript.

The function call `randFixedSum(n,m,s,a,b)` returns an array of `m` arrays, each having `n` random elements between
`a` and `b` which sum up to `s`.
For example, the following command writes `10` CSV rows to `stdout`, each having `3` columns with values between `0` and `1` which sum up to `1.25` - for this to work you need to have [CoffeeScript](http://coffescript.org) running on [Node.js](http://nodejs.org):

    coffee -e "require './randfixedsum.coffee'; console.log r.join ',' for r in randFixedSum 3,10,1.25,0,1"

<table><tr><td>
To test the uniformness of the generated random numbers, I tried to come up with the same scatterplot
of `randFixedSum 3,16384,1.25,0,1`, that is 
[shown on MATLAB Central](http://www.mathworks.com/matlabcentral/fx_files/9700/1/randfixedsum_example.jpg).
The result is shown on the right - it's derived from [slide 34](http://fhtr.org/BasicsOfThreeJS/#34) of the Tutorial
[Three.js Basics by Ilmari Heikkinen](http://fhtr.org/BasicsOfThreeJS). Click the scatterplot for the interactive page.
</td><td>
<a href="http://bstr.at/randFixedSum/scatterplot/" target="_blank">
  <img src="https://github.com/bstrat/randFixedSum/raw/master/scatterplot/sp.png" width="480" height="400" />
</a>
</td></tr><table>
