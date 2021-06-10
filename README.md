![Linux Build Status (Github Actions)](https://github.com/ayman-albaz/distances/actions/workflows/install_and_test.yml/badge.svg) [![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

# Distances

Distances is a high performance Nim library for calculating distances.

This library is designed to allow users to calculate common distance metrics across all the popular sequence based libraries in Nim.

## Supported Libraries
Current supported sequence based libraries include:
1. [sequtils](https://github.com/nim-lang/Nim/blob/devel/lib/pure/collections/sequtils.nim)
2. [arraymancer](https://github.com/mratsim/Arraymancer)
3. [neo](https://github.com/andreaferretti/neo)


## Supported Distance Metrics
Current supported distance metrics include:

| Distance          | Command                         |
|-------------------|---------------------------------|
| Hamming           | hamming_distance(x1, x2)        |
| Euclidean         | euclidean_distance(x1, x2)      |
| Squared Euclidean | sqeuclidean_distance(x1, x2)    |
| City Block        | cityblock_distance(x1, x2)      |
| Total Variation   | totalvariation_distance(x1, x2) |
| Jaccard           | jaccard_distance(x1, x2)        |
| Cosine            | cosine_distance(x1, x2)         |
| KL Divergence     | kldivergence_distance(x1, x2)   |

## Examples 

### Calculating Cosine Distance - sequtils
Note: All computations are done row-wise.
```Nim
import sequtils
import distances/seq

let 
    num_rows = 100
    num_cols = 100
    input_seq_int = newSeq[int](num_cols)
    input_seq_seq_int = newSeqWith(num_rows, newSeq[int](num_cols))

# 1D distance
echo cosine_distance(input_seq_int, input_seq_int)

# 2D distance (Pairwise)
echo pairwise(input_seq_seq_int, cosine_distance)
```


### Calculating Cosine Distance - arraymancer
Note: Only 2D Tensors are supported. All computations are done column wise.
```Nim
import arraymancer
import distances/tensor

let 
    num_rows = 100
    num_cols = 100
    input_tensor_1d_int = zeros[int](1, num_cols)
    input_tensor_2d_int = zeros[int](num_rows, num_cols)

# 1D distance
echo cosine_distance(input_tensor_1d_int, input_tensor_1d_int)

# 2D distance (Pairwise)
echo pairwise(input_tensor_2d_int, cosine_distance)
```


### Calculating Cosine Distance - neo
Note: All computations are done column wise.
Warning: Neo matrices seem to run 1-2 order of magnitudes slower than sequtils and arraymancer. Please contact me or submit a PR if you know why.
```Nim
import neo
import distances/vector

let 
    num_rows = 100
    num_cols = 100
    input_vector_int = makeVector(num_cols, proc(i: int): int = 0)
    input_matrix_int = makeMatrix(num_rows, num_cols, proc(i, j: int): int = 0)

# 1D distance
echo cosine_distance(input_vector_int, input_vector_int)

# 2D distance (Pairwise)
echo pairwise(input_matrix_int, cosine_distance)
```

### Normalization
All distance metrics support the optional `normalize` (defaults to `false`) parameter. This normalizes distance outputs (between -1 and 1). Note, while all distance metrics have this parameter only, it will do nothing for jaccard, cosine, and KL divergence distances.

E.g.
```Nim
discard cosine_distance(input_vector_int, input_vector_int, normalize=true)
discard pairwise(input_matrix_int, cosine_distance, normalize=true)
```

### Symmetry
The `pairwise` procs always compute the lower left triangle of the 2D sequence to save time. To get a full matrix, use the `symmetrize(X, how: string = "l=>u")` proc.

E.g.
```Nim
discard symmetrize(X, "l=>u")	# Copy lower left triangle to upper right triangle
discard symmetrize(X, "u=>l")	# Copy upper right triangle to lower left triangle
``` 

## Performance

To get optimal performance, here are the recommended compiler flags:
`nim --cc:gcc --passC:"-fopenmp -ffast-math" --passL:"-fopenmp -ffast-math" --d:release -t:-mavx2 -t:-mfma c -r myScript.nim`.
- openmp -> Multiprocessing for the `pairwise` procs. Number of threads is equal to ENV variable `OMP_NUM_THREADS`.
- ffast-math -> ~2x float multiplication speedups
- d:release -> ~100x pairwise speedup
- d:danger -> ~120x pairwise speedup
- t:-mavx2 and -t:-mfma -> ~0.20x pairwise speedup


## TODO
- Neo matrices seem to run 1-2 orders of magnitudes slower than sequtils and arraymancer. The reason is unknown to me.
- Add more distance metrics
- Add support for distance metrics with more than 2 arguments

Performance, feature, and documentation PR's are always welcome.


## Contact
I can be reached at aymanalbaz98@gmail.com

