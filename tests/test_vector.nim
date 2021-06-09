import neo
import times
import unittest

import distances/vector

# Globals
let
    num_rows = 10
    num_cols = 10
    input_matrix_int = makeMatrix(num_rows, num_cols, proc(i, j: int): int = 0.int)
    input_matrix_float = makeMatrix(num_rows, num_cols, proc(i, j: int): float = 0.float)
    output_matrix_float = makeMatrix(num_rows, num_rows, proc(i, j: int): float = 0.float)
    normalize = true

suite "Vector":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "pairwise int hamming":
        check pairwise(input_matrix_int, hamming_distance, normalize) == output_matrix_float

    test "pairwise int euclidean":
        check pairwise(input_matrix_int, euclidean_distance, normalize) == output_matrix_float

    test "pairwise int sqeuclidean":
        check pairwise(input_matrix_int, sqeuclidean_distance, normalize) == output_matrix_float

    test "pairwise int cityblock":
        check pairwise(input_matrix_int, cityblock_distance, normalize) == output_matrix_float

    test "pairwise int totalvariation":
        check pairwise(input_matrix_int, totalvariation_distance, normalize) == output_matrix_float

    test "pairwise int jaccard":
        check pairwise(input_matrix_int, jaccard_distance, normalize) == output_matrix_float

    test "pairwise int cosine":
        check pairwise(input_matrix_int, cosine_distance, normalize) == output_matrix_float

    test "pairwise int kldivergence":
        check pairwise(input_matrix_int, kldivergence_distance, normalize) == output_matrix_float

    test "pairwise float hamming":
        check pairwise(input_matrix_float, hamming_distance, normalize) == output_matrix_float

    test "pairwise float euclidean":
        check pairwise(input_matrix_float, euclidean_distance, normalize) == output_matrix_float

    test "pairwise float sqeuclidean":
        check pairwise(input_matrix_float, sqeuclidean_distance, normalize) == output_matrix_float

    test "pairwise float cityblock":
        check pairwise(input_matrix_float, cityblock_distance, normalize) == output_matrix_float

    test "pairwise float totalvariation":
        check pairwise(input_matrix_float, totalvariation_distance, normalize) == output_matrix_float

    test "pairwise float jaccard":
        check pairwise(input_matrix_float, jaccard_distance, normalize) == output_matrix_float

    test "pairwise float cosine":
        check pairwise(input_matrix_float, cosine_distance, normalize) == output_matrix_float

    test "pairwise float kldivergence":
        check pairwise(input_matrix_float, kldivergence_distance, normalize) == output_matrix_float

    test "symmetrize l=>u":
        let input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]].matrix()
        let output = @[@[1, 11, 111], @[11, 22, 222], @[111, 222, 333]].matrix()
        check symmetrize(input) == output

    test "symmetrize u=>l":
        let input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]].matrix()
        let output = @[@[1, 2, 3], @[2, 22, 33], @[3, 33, 333]].matrix()
        check symmetrize(input, "u=>l") == output

    test "symmetrize mut l=>u":
        var input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]].matrix()
        var output = @[@[1, 11, 111], @[11, 22, 222], @[111, 222, 333]].matrix()
        check symmetrize(input) == output

    test "symmetrize mut u=>l":
        var input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]].matrix()
        var output = @[@[1, 2, 3], @[2, 22, 33], @[3, 33, 333]].matrix()
        check symmetrize(input, "u=>l") == output
