import sequtils
import times
import unittest

import distances/seq


# Globals
let
    num_rows = 10
    num_cols = 10
    input_seq_seq_int = newSeqWith(num_rows, newSeq[int](num_cols))
    input_seq_seq_float = newSeqWith(num_rows, newSeq[float](num_cols))
    output_seq_float = newSeqWith(num_rows, newSeq[float](num_rows))
    normalize = true

suite "Seq":
    
    setup:
        let t0 = getTime()

    teardown:
        echo "\n  RUNTIME: ", getTime() - t0

    test "pairwise int hamming":
        check pairwise(input_seq_seq_int, hamming_distance, normalize) == output_seq_float

    test "pairwise int euclidean":
        check pairwise(input_seq_seq_int, euclidean_distance, normalize) == output_seq_float

    test "pairwise int sqeuclidean":
        check pairwise(input_seq_seq_int, sqeuclidean_distance, normalize) == output_seq_float

    test "pairwise int cityblock":
        check pairwise(input_seq_seq_int, cityblock_distance, normalize) == output_seq_float

    test "pairwise int totalvariation":
        check pairwise(input_seq_seq_int, totalvariation_distance, normalize) == output_seq_float

    test "pairwise int jaccard":
        check pairwise(input_seq_seq_int, jaccard_distance, normalize) == output_seq_float

    test "pairwise int cosine":
        check pairwise(input_seq_seq_int, cosine_distance, normalize) == output_seq_float

    test "pairwise int kldivergence":
        check pairwise(input_seq_seq_int, kldivergence_distance, normalize) == output_seq_float

    test "pairwise float hamming":
        check pairwise(input_seq_seq_float, hamming_distance, normalize) == output_seq_float

    test "pairwise float euclidean":
        check pairwise(input_seq_seq_float, euclidean_distance, normalize) == output_seq_float

    test "pairwise float sqeuclidean":
        check pairwise(input_seq_seq_float, sqeuclidean_distance, normalize) == output_seq_float

    test "pairwise float cityblock":
        check pairwise(input_seq_seq_float, cityblock_distance, normalize) == output_seq_float

    test "pairwise float totalvariation":
        check pairwise(input_seq_seq_float, totalvariation_distance, normalize) == output_seq_float

    test "pairwise float jaccard":
        check pairwise(input_seq_seq_float, jaccard_distance, normalize) == output_seq_float

    test "pairwise float cosine":
        check pairwise(input_seq_seq_float, cosine_distance, normalize) == output_seq_float

    test "pairwise float kldivergence":
        check pairwise(input_seq_seq_float, kldivergence_distance, normalize) == output_seq_float

    test "symmetrize l=>u":
        let input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]]
        let output = @[@[1, 11, 111], @[11, 22, 222], @[111, 222, 333]]
        check symmetrize(input) == output

    test "symmetrize seq sesq u=>l":
        let input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]]
        let output = @[@[1, 2, 3], @[2, 22, 33], @[3, 33, 333]]
        check symmetrize(input, "u=>l") == output

    test "symmetrize mut l=>u":
        var input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]]
        var output = @[@[1, 11, 111], @[11, 22, 222], @[111, 222, 333]]
        check symmetrize(input) == output

    test "symmetrize mut u=>l":
        var input = @[@[1, 2, 3], @[11, 22, 33], @[111, 222, 333]]
        var output = @[@[1, 2, 3], @[2, 22, 33], @[3, 33, 333]]
        check symmetrize(input, "u=>l") == output
