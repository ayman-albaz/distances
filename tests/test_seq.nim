import std/math
import std/sequtils
import std/unittest
import distances/seq

suite "Distance functions":

  test "hamming distance":
    check hammingDistance(@[1, 2, 3], @[1, 3, 3]) == 1.0
    check hammingDistance(@[1, 2, 3], @[4, 5, 6]) == 3.0

  test "hamming distance normalized":
    check hammingDistance(@[1, 2, 3], @[1, 3, 3], normalize = true) == 1.0 / 3.0

  test "euclidean distance":
    check euclideanDistance(@[0.0, 0.0], @[3.0, 4.0]) == 5.0

  test "euclidean distance normalized":
    check euclideanDistance(@[0.0, 0.0], @[3.0, 4.0], normalize = true) == 5.0 / 2.0

  test "squared euclidean distance":
    check squaredEuclideanDistance(@[0.0, 0.0], @[3.0, 4.0]) == 25.0

  test "cityblock distance":
    check cityblockDistance(@[0, 0], @[3, 4]) == 7.0

  test "total variation distance":
    check totalVariationDistance(@[0, 0], @[3, 4]) == 3.5

  test "jaccard distance":
    check jaccardDistance(@[1, 2], @[2, 3]) == 0.4

  test "cosine distance":
    check cosineDistance(@[1.0, 0.0], @[0.0, 1.0]) == 1.0

  test "kl divergence distance":
    let x1 = @[0.5'f64, 0.5'f64]
    let x2 = @[0.25'f64, 0.75'f64]
    let expected = 0.5 * ln(2.0) + 0.5 * ln(2.0 / 3.0)
    check abs(klDivergenceDistance(x1, x2) - expected) < 1e-10

  test "kl divergence with zero in first vector":
    let x1 = @[0.0'f64, 0.5'f64]
    let x2 = @[0.25'f64, 0.5'f64]
    let expected = 0.0 + 0.5 * ln(0.5 / 0.5)
    check abs(klDivergenceDistance(x1, x2) - expected) < 1e-10

  test "kl divergence with zero in second vector":
    let x1 = @[0.5'f64, 0.5'f64]
    let x2 = @[0.0'f64, 0.5'f64]
    check klDivergenceDistance(x1, x2) == Inf

  test "distance with mismatched lengths raises ValueError":
    expect(ValueError):
      discard euclideanDistance(@[1, 2], @[1, 2, 3])

suite "Pairwise":

  test "pairwise basic":
    let X = @[
      @[1.0, 0.0],
      @[0.0, 1.0],
      @[1.0, 1.0]
    ]
    let dist = pairwise(X, euclideanDistance)
    check dist[0][0] == 0.0
    check dist[1][0] == euclideanDistance(X[1], X[0])
    check dist[1][1] == 0.0
    check dist[2][0] == euclideanDistance(X[2], X[0])
    check dist[2][1] == euclideanDistance(X[2], X[1])
    check dist[2][2] == 0.0

  test "pairwise with normalize":
    let X = @[
      @[1.0, 0.0],
      @[0.0, 1.0]
    ]
    let dist = pairwise(X, euclideanDistance, normalize = true)
    check dist[0][0] == 0.0
    check dist[1][0] == euclideanDistance(X[1], X[0], normalize = true)
    check dist[1][1] == 0.0

  test "pairwise preallocated":
    let X = @[
      @[1.0, 0.0],
      @[0.0, 1.0],
      @[1.0, 1.0]
    ]
    var dist = newSeqWith(3, newSeq[float](3))
    pairwise(dist, X, euclideanDistance)
    check dist[0][0] == 0.0
    check dist[1][0] == euclideanDistance(X[1], X[0])
    check dist[1][1] == 0.0
    check dist[2][0] == euclideanDistance(X[2], X[0])
    check dist[2][1] == euclideanDistance(X[2], X[1])
    check dist[2][2] == 0.0

  test "pairwise preallocated too small raises ValueError":
    let X = @[
      @[1.0, 0.0],
      @[0.0, 1.0]
    ]
    var dist = newSeqWith(1, newSeq[float](1))
    expect(ValueError):
      pairwise(dist, X, euclideanDistance)

suite "Symmetrize":

  test "symmetrize lower to upper":
    let input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]]
    let output = @[@[1, 11, 111], @[11, 22, 222], @[111, 222, 333]]
    check symmetrize(input) == output
    check symmetrize(input, sdLowerToUpper) == output

  test "symmetrize upper to lower":
    let input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]]
    let output = @[@[1, 2, 3], @[2, 22, 33], @[3, 33, 333]]
    check symmetrize(input, sdUpperToLower) == output

  test "symmetrize mutable lower to upper":
    var input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]]
    let output = @[@[1, 11, 111], @[11, 22, 222], @[111, 222, 333]]
    symmetrize(input)
    check input == output

  test "symmetrize mutable upper to lower":
    var input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]]
    let output = @[@[1, 2, 3], @[2, 22, 33], @[3, 33, 333]]
    symmetrize(input, sdUpperToLower)
    check input == output

  test "symmetrize non-square raises ValueError":
    expect(ValueError):
      discard symmetrize(@[@[1, 2], @[3, 4], @[5, 6]])
