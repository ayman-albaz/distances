{.experimental: "strictFuncs".}

import std/math
import std/sequtils

type
  SymmetrizeDir* = enum
    sdLowerToUpper  ## Copy the lower triangle to the upper triangle
    sdUpperToLower  ## Copy the upper triangle to the lower triangle

template checkSameLength(x1, x2: openArray) =
  if x1.len != x2.len:
    raise newException(ValueError, "Input arrays must have the same length")

template applyNormalize(result: var float, n: int, normalize: bool) =
  if normalize and n > 0:
    result = result / n.float

func sumOfSquaredDiffs[T: SomeNumber](x1, x2: openArray[T]): float =
  let n = x1.len
  result = 0.0
  for k in 0 ..< n:
    let d = x1[k].float - x2[k].float
    result += d * d

func sumOfAbsDiffs[T: SomeNumber](x1, x2: openArray[T]): float =
  let n = x1.len
  result = 0.0
  for k in 0 ..< n:
    result += abs(x1[k].float - x2[k].float)

func hammingDistance*[T: SomeNumber](x1, x2: openArray[T], normalize: bool = false): float =
  ## Computes the Hamming distance between two arrays.
  ##
  ## The Hamming distance is the number of positions at which the
  ## corresponding elements are different.
  checkSameLength(x1, x2)
  let n = x1.len
  var total = 0
  for k in 0 ..< n:
    total += int(x1[k] != x2[k])
  result = total.float
  applyNormalize(result, n, normalize)

func euclideanDistance*[T: SomeNumber](x1, x2: openArray[T], normalize: bool = false): float =
  ## Computes the Euclidean (L2) distance between two arrays.
  checkSameLength(x1, x2)
  let n = x1.len
  result = sqrt(sumOfSquaredDiffs(x1, x2))
  applyNormalize(result, n, normalize)

func squaredEuclideanDistance*[T: SomeNumber](x1, x2: openArray[T], normalize: bool = false): float =
  ## Computes the squared Euclidean distance between two arrays.
  checkSameLength(x1, x2)
  let n = x1.len
  result = sumOfSquaredDiffs(x1, x2)
  applyNormalize(result, n, normalize)

func cityblockDistance*[T: SomeNumber](x1, x2: openArray[T], normalize: bool = false): float =
  ## Computes the city block (Manhattan, L1) distance between two arrays.
  checkSameLength(x1, x2)
  let n = x1.len
  result = sumOfAbsDiffs(x1, x2)
  applyNormalize(result, n, normalize)

func totalVariationDistance*[T: SomeNumber](x1, x2: openArray[T], normalize: bool = false): float =
  ## Computes the total variation distance between two arrays.
  checkSameLength(x1, x2)
  let n = x1.len
  result = sumOfAbsDiffs(x1, x2) / 2.0
  applyNormalize(result, n, normalize)

func jaccardDistance*[T: SomeNumber](x1, x2: openArray[T], normalize: bool = false): float =
  ## Computes the Jaccard distance between two arrays.
  ##
  ## Returns `1 - (sum(min(x1, x2)) / sum(max(x1, x2)))`.
  ## The `normalize` parameter is accepted for API consistency but has no effect.
  checkSameLength(x1, x2)
  let n = x1.len
  var totalMin = 0.0
  var totalMax = 0.0
  for k in 0 ..< n:
    let a = x1[k].float
    let b = x2[k].float
    totalMin += min(a, b)
    totalMax += max(a, b)
  if totalMax == 0.0:
    result = 0.0
  else:
    result = 1.0 - totalMin / totalMax

func cosineDistance*[T: SomeNumber](x1, x2: openArray[T], normalize: bool = false): float =
  ## Computes the cosine distance between two arrays.
  ##
  ## Returns `1 - cosine_similarity`. The `normalize` parameter is accepted
  ## for API consistency but has no effect.
  checkSameLength(x1, x2)
  let n = x1.len
  var totalX1X2 = 0.0
  var totalX1Sq = 0.0
  var totalX2Sq = 0.0
  for k in 0 ..< n:
    let a = x1[k].float
    let b = x2[k].float
    totalX1X2 += a * b
    totalX1Sq += a * a
    totalX2Sq += b * b
  if totalX1Sq == 0.0 or totalX2Sq == 0.0:
    result = 0.0
  else:
    result = 1.0 - totalX1X2 / (sqrt(totalX1Sq) * sqrt(totalX2Sq))

func klDivergenceDistance*[T: SomeNumber](x1, x2: openArray[T], normalize: bool = false): float =
  ## Computes the Kullback-Leibler divergence from `x2` to `x1`.
  ##
  ## The `normalize` parameter is accepted for API consistency but has no effect.
  checkSameLength(x1, x2)
  let n = x1.len
  var total = 0.0
  for k in 0 ..< n:
    let a = x1[k].float
    let b = x2[k].float
    if a == 0.0:
      continue
    if b == 0.0:
      return Inf
    total += a * ln(a / b)
  result = total

func pairwise*[T: SomeNumber](X: openArray[seq[T]], distance: (proc(x1, x2: openArray[T], normalize: bool): float {.noSideEffect.}), normalize: bool = false): seq[seq[float]] =
  ## Computes the pairwise distance matrix for a collection of vectors.
  ##
  ## The returned matrix is lower-triangular (including the diagonal).
  ## Use `symmetrize` to obtain a full symmetric matrix.
  let numRows = X.len
  result = newSeqWith(numRows, newSeq[float](numRows))
  for i in 0 ..< numRows:
    for j in 0 .. i:
      result[i][j] = distance(X[i], X[j], normalize)

proc pairwise*[T: SomeNumber](dst: var seq[seq[float]], X: openArray[seq[T]], distance: (proc(x1, x2: openArray[T], normalize: bool): float {.noSideEffect.}), normalize: bool = false) =
  ## Fills a preallocated pairwise distance matrix for a collection of vectors.
  ##
  ## The `dst` matrix must have at least `X.len` rows and columns.
  ## Only the lower triangle (including the diagonal) is written.
  let numRows = X.len
  if dst.len < numRows:
    raise newException(ValueError, "Result matrix has too few rows")
  for i in 0 ..< numRows:
    if dst[i].len < numRows:
      raise newException(ValueError, "Result matrix row " & $i & " has too few columns")
  for i in 0 ..< numRows:
    for j in 0 .. i:
      dst[i][j] = distance(X[i], X[j], normalize)

func symmetrize*[T: SomeNumber](X: openArray[seq[T]], how: SymmetrizeDir = sdLowerToUpper): seq[seq[T]] =
  ## Returns a symmetrized copy of a square matrix.
  let numRows = X.len
  if numRows == 0:
    return @[]
  let numCols = X[0].len
  if numRows != numCols:
    raise newException(ValueError, "Matrix must be square")
  result = newSeqWith(numRows, newSeq[T](numCols))
  for i in 0 ..< numRows:
    for j in 0 ..< numCols:
      result[i][j] = X[i][j]
  if how == sdLowerToUpper:
    for i in 0 ..< numCols:
      for j in 0 .. i:
        result[j][i] = X[i][j]
  else:
    for i in 0 ..< numCols:
      for j in 0 .. i:
        result[i][j] = X[j][i]

proc symmetrize*[T: SomeNumber](X: var seq[seq[T]], how: SymmetrizeDir = sdLowerToUpper) =
  ## Mutates a square matrix to make it symmetric in-place.
  let numRows = X.len
  if numRows == 0:
    return
  let numCols = X[0].len
  if numRows != numCols:
    raise newException(ValueError, "Matrix must be square")
  if how == sdLowerToUpper:
    for i in 0 ..< numCols:
      for j in 0 .. i:
        X[j][i] = X[i][j]
  else:
    for i in 0 ..< numCols:
      for j in 0 .. i:
        X[i][j] = X[j][i]

when defined(distancesUseWeave):
  import weave

  proc pairwiseWeave*[T: SomeNumber](dst: var seq[seq[float]], X: openArray[seq[T]], distance: (proc(x1, x2: openArray[T], normalize: bool): float {.noSideEffect.}), normalize: bool = false) =
    ## Fills a preallocated pairwise distance matrix using Weave for parallel execution.
    ## The Weave runtime must be initialized by the caller before invoking this proc.
    let numRows = X.len
    if dst.len < numRows:
      raise newException(ValueError, "Result matrix has too few rows")
    for i in 0 ..< numRows:
      if dst[i].len < numRows:
        raise newException(ValueError, "Result matrix row " & $i & " has too few columns")

    syncScope():
      parallelFor i in 0 ..< numRows:
        captures: {numRows, X, dst, distance, normalize}
        for j in 0 .. i:
          dst[i][j] = distance(X[i], X[j], normalize)
