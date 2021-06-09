import arraymancer
import times
import unittest

import distances/tensor

# Globals
let
    num_rows = 10
    num_cols = 10
    input_tensor_int = zeros[int](num_rows, num_cols)
    input_tensor_float = zeros[float](num_rows, num_cols)
    output_tensor_float = zeros[float](num_cols, num_cols)
    normalize = true

suite "Tensor":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "pairwise int hamming":
        check pairwise(input_tensor_int, hamming_distance, normalize) == output_tensor_float

    test "pairwise int euclidean":
        check pairwise(input_tensor_int, euclidean_distance, normalize) == output_tensor_float

    test "pairwise int sqeuclidean":
        check pairwise(input_tensor_int, sqeuclidean_distance, normalize) == output_tensor_float

    test "pairwise int cityblock":
        check pairwise(input_tensor_int, cityblock_distance, normalize) == output_tensor_float

    test "pairwise int totalvariation":
        check pairwise(input_tensor_int, totalvariation_distance, normalize) == output_tensor_float

    test "pairwise int jaccard":
        check pairwise(input_tensor_int, jaccard_distance, normalize) == output_tensor_float

    test "pairwise int cosine":
        check pairwise(input_tensor_int, cosine_distance, normalize) == output_tensor_float

    test "pairwise int kldivergence":
        check pairwise(input_tensor_int, kldivergence_distance, normalize) == output_tensor_float

    test "pairwise float hamming":
        check pairwise(input_tensor_float, hamming_distance, normalize) == output_tensor_float

    test "pairwise float euclidean":
        check pairwise(input_tensor_float, euclidean_distance, normalize) == output_tensor_float

    test "pairwise float sqeuclidean":
        check pairwise(input_tensor_float, sqeuclidean_distance, normalize) == output_tensor_float

    test "pairwise float cityblock":
        check pairwise(input_tensor_float, cityblock_distance, normalize) == output_tensor_float

    test "pairwise float totalvariation":
        check pairwise(input_tensor_float, totalvariation_distance, normalize) == output_tensor_float

    test "pairwise float jaccard":
        check pairwise(input_tensor_float, jaccard_distance, normalize) == output_tensor_float

    test "pairwise float cosine":
        check pairwise(input_tensor_float, cosine_distance, normalize) == output_tensor_float

    test "pairwise float kldivergence":
        check pairwise(input_tensor_float, kldivergence_distance, normalize) == output_tensor_float

    test "symmetrize tensor l=>u":
        let input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]].toTensor()
        let output = @[@[1, 11, 111], @[11, 22, 222], @[111, 222, 333]].toTensor()
        check symmetrize(input) == output

    test "symmetrize tensor u=>l":
        let input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]].toTensor()
        let output = @[@[1, 2, 3], @[2, 22, 33], @[3, 33, 333]].toTensor()
        check symmetrize(input, "u=>l") == output

    test "symmetrize mut tensor l=>u":
        var input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]].toTensor()
        var output = @[@[1, 11, 111], @[11, 22, 222], @[111, 222, 333]].toTensor()
        check symmetrize(input) == output

    test "symmetrize mut tensor u=>l":
        var input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]].toTensor()
        var output = @[@[1, 2, 3], @[2, 22, 33], @[3, 33, 333]].toTensor()
        check symmetrize(input, "u=>l") == output

