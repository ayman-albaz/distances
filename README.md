![Linux Build Status (Github Actions)](https://github.com/ayman-albaz/distances/actions/workflows/install_and_test.yml/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Distances

Distances is a high performance Nim library for calculating distances.

This library is designed to allow users to calculate common distance metrics using pure Nim sequences.


## Supported Distance Metrics

Current supported distance metrics include:

| Distance          | Command                           | Normalized Variant                    |
|-------------------|-----------------------------------|-------------------------------------|
| Hamming           | `hammingDistance(x1, x2)`         | `normalizedHammingDistance(x1, x2)` |
| Euclidean         | `euclideanDistance(x1, x2)`       | `normalizedEuclideanDistance(x1, x2)` |
| Squared Euclidean | `squaredEuclideanDistance(x1, x2)`| `normalizedSquaredEuclideanDistance(x1, x2)` |
| City Block        | `cityblockDistance(x1, x2)`       | `normalizedCityblockDistance(x1, x2)` |
| Total Variation   | `totalVariationDistance(x1, x2)`  | `normalizedTotalVariationDistance(x1, x2)` |
| Jaccard           | `jaccardDistance(x1, x2)`         | —                                   |
| Cosine            | `cosineDistance(x1, x2)`          | —                                   |
| KL Divergence     | `klDivergenceDistance(x1, x2)`      | —                                   |

### Normalized Distances

For metrics that support it, a normalized variant divides the raw distance by the vector length (`n`). This scales the result to the range `[0, 1]` (or similar, depending on the metric). The normalized variants are provided as separate functions (e.g., `normalizedEuclideanDistance`).

### Edge Cases

- **Cosine distance** returns `NaN` if either input vector has zero magnitude, since cosine similarity is undefined in that case.
- **KL divergence** returns `NaN` if any element is negative (invalid probability distribution) and `Inf` if `x1[k] > 0` while `x2[k] == 0`.
- **Jaccard distance** returns `0.0` when both inputs contain only zeros (convention for empty sets).
- All distances return `0.0` for empty arrays of equal length.

## Examples

### Calculating Cosine Distance

Note: All computations are done row-wise.

```Nim
import sequtils
import distances

let
    num_rows = 100
    num_cols = 100
    input_seq_int = newSeq[int](num_cols)
    input_seq_seq_int = newSeqWith(num_rows, newSeq[int](num_cols))

# 1D distance
echo cosineDistance(input_seq_int, input_seq_int)

# 2D distance (Pairwise)
echo pairwise(input_seq_seq_int, cosineDistance)
```

### Normalization

Use the dedicated normalized functions when you need length-normalized results:

```Nim
import distances

discard normalizedEuclideanDistance(@[0.0, 0.0], @[3.0, 4.0])
discard pairwise(@[@[0.0, 0.0], @[3.0, 4.0]], normalizedEuclideanDistance)
```

### Symmetry

The `pairwise` proc computes only the lower-left triangle (including the diagonal) to save time. To obtain a full symmetric matrix, use `symmetrize` with the `SymmetrizeDir` enum.

```Nim
import distances

discard symmetrize(X, sdLowerToUpper)  # Copy lower triangle to upper triangle
discard symmetrize(X, sdUpperToLower)  # Copy upper triangle to lower triangle
```

### Working with arrays and other sequences

All 1D distance functions accept `openArray[T]`, so they work with `seq`, `array`, and string slices interchangeably:

```Nim
let a = [1, 2, 3]
let b = [1, 3, 3]
echo hammingDistance(a, b)  # Works with arrays too
```

## Performance

To get optimal performance, compile with `--d:release` or `--d:danger`:
- `--d:release` -> ~100x pairwise speedup
- `--d:danger` -> ~120x pairwise speedup


## TODO
- Add more distance metrics
- Add support for distance metrics with more than 2 arguments

Performance, feature, and documentation PR's are always welcome.


## Contact

I can be reached at aymanalbaz98@gmail.com
