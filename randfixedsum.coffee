# A port of the MATLAB function randfixedsum by Roger Stafford
# Stefan Baumann
# 26 June 2013

matrixOf = (f, n, m) ->
  (f() for j in [0...m]) for i in [0...n]
zerosMatrix = (n, m) ->
  matrixOf (->0), n, m
randomMatrix = (n, m) ->
  matrixOf (->Math.random()), n, m
vectorOf = (f, n) ->
  f() for i in [0...n]
randPerm = (n) ->
  ([i, Math.random()] for i in [0...n]).sort( (a,b) -> a[1] < b[1] ).map (p) -> p[0]

typeOfSimplex = (n, k, s) ->
  s1 = (s-i for i in [k..k-n+1])
  s2 = (i-s for i in [k+n..k+1])
  t = zerosMatrix n-1, n
  w = zerosMatrix n, n+1
  w[0][1] = Number.MAX_VALUE
  [_1, _2, _3, _4] = [[], [], [], []]
  for i in [1...n]
    for j in [0..i]
      _1[j] = w[i-1][j+1] * s1[j] / (i+1)
      _2[j] = w[i-1][j] * s2[n-i-1+j] / (i+1)
      w[i][j+1] = _1[j] + _2[j]
      _3[j] = w[i][j+1] + Number.MIN_VALUE
      _4[j] = s2[n-i-1+j] > s1[j]
      t[i-1][j] = _4[j]*_2[j]/_3[j] + !_4[j]*(1 - _1[j]/_3[j])
  t[0][n] = w[n-1][k+1]/Number.MAX_VALUE
  t

randFixedSum = (n, m, s, a, b, v=undefined) ->
  s = (s - n*a)/(b - a)
  k = Math.max Math.min( Math.floor(s), n-1 ), 0
  s = Math.max Math.min(s, k+1), k
  t = typeOfSimplex n, k, s
  v = Math.pow(n, 1.5) * (t[0][n]) * Math.pow(b-a, n-1) if v?
  #
  xs = zerosMatrix n, m
  rt = randomMatrix n-1, m
  rs = randomMatrix n-1, m
  [_s, js, sm, pr] = [ s, k, 0, 1 ].map (x) -> vectorOf (->x), m
  [es, sx] = [[], []]
  #
  for i in [n..2]
    for j in [0...m]
      es[j] = rt[n-i][j] <= t[i-2][js[j]]
      sx[j] = Math.pow rs[n-i][j], 1/(i-1)
      sm[j] = sm[j] + (1-sx[j]) * pr[j] * _s[j]/i
      pr[j] = sx[j] * pr[j]
      xs[n-i][j] = sm[j] + pr[j] * es[j]
      _s[j] = _s[j] - es[j]
      js[j] = js[j] - es[j]
  xs[n-1][j] = sm[j] + pr[j] * _s[j] for j in [0...m]
  #
  ps = vectorOf (->randPerm(n)), m
  if v? then v else [0...m].map (j) -> [0...n].map (i) -> a + (b-a) * xs[ps[j][i]][j]

global.randFixedSum = randFixedSum if global?
