type
    Submodule* = object
        name*: string

proc initSubmodule*(): Submodule =
    Submodule(name: "Anonymous")


import Arraymancer
import math

{.nanChecks: on, infChecks: on.}
proc hamming_distance*[T: SomeNumber](x1, x2: Tensor[T], normalize: bool = false): float =
    let num_rows = x1.shape[0]
    var total: int32 = 0
    for k in 0..num_rows-1:
        total += (x1[k, 0] != x2[k, 0]).int32
    if normalize:
        return total.float / num_rows.float
    else:
        return total.float


proc euclidean_distance*[T: SomeNumber](x1, x2: Tensor[T], normalize: bool = false): float =
    let num_rows = x1.shape[0]
    var total: typeof(x1[0]) = 0
    var total_intermediate: typeof(x1[0]) = 0
    for k in 0..num_rows-1:
        total_intermediate = (x1[k, 0] - x2[k, 0])
        total += total_intermediate * total_intermediate
    if normalize:
        return sqrt(total.float) / num_rows.float
    else:
        return sqrt(total.float)


proc sqeuclidean_distance*[T: SomeNumber](x1, x2: Tensor[T], normalize: bool = false): float =
    let num_rows = x1.shape[0]
    var total: typeof(x1[0]) = 0
    var total_intermediate: typeof(x1[0]) = 0
    for k in 0..num_rows-1:
        total_intermediate = (x1[k, 0] - x2[k, 0])
        total += total_intermediate * total_intermediate
    if normalize:
        return total.float / num_rows.float
    else:
        return total.float


proc cityblock_distance*[T: SomeNumber](x1, x2: Tensor[T], normalize: bool = false): float =
    let num_rows = x1.shape[0]
    var total: typeof(x1[0]) = 0
    for k in 0..num_rows-1:
        total += abs(x1[k, 0] - x2[k, 0])
    if normalize:
        return total.float / num_rows.float
    else:
        return total.float


proc totalvariation_distance*[T: SomeNumber](x1, x2: Tensor[T], normalize: bool = false): float =
    let num_rows = x1.shape[0]
    var total: typeof(x1[0]) = 0
    for k in 0..num_rows-1:
        total += abs(x1[k, 0] - x2[k, 0])
    if normalize:
        return total.float / 2.0.float / num_rows.float
    else:
        return total.float / 2.0.float


proc jaccard_distance*[T: SomeNumber](x1, x2: Tensor[T], normalize: bool = false): float =
    let num_rows = x1.shape[0]
    var 
        total_min: typeof(x1[0]) = 0
        total_max: typeof(x1[0]) = 0
    for k in 0..num_rows-1:
        total_min += min(x1[k, 0], x2[k, 0])
        total_max += max(x1[k, 0], x2[k, 0])
    if total_max == 0:
        return 0.0.float
    else:
        return 1.0.float - (total_min / total_max).float


proc cosine_distance*[T: SomeNumber](x1, x2: Tensor[T], normalize: bool = false): float =
    let num_rows = x1.shape[0]
    var 
        total_x12: typeof(x1[0]) = 0
        total_x11: typeof(x1[0]) = 0
        total_x22: typeof(x1[0]) = 0
    for k in 0..num_rows-1:
        total_x12 += x1[k, 0] * x2[k, 0]
        total_x11 += x1[k, 0] * x1[k, 0]
        total_x22 += x2[k, 0] * x2[k, 0]
    if total_x11 == 0 or total_x22 == 0:
        return 0.0.float
    else:
        return 1.0.float - total_x12.float / (sqrt(total_x11.float) * sqrt(total_x22.float))


proc kldivergence_distance*[T: SomeNumber](x1, x2: Tensor[T], normalize: bool = false): float =
    let num_rows = x1.shape[0]
    var total: float
    for k in 0..num_rows-1:
        if x1[k, 0] == 0 and x2[k, 0] == 0:
            continue
        else:
            total += x1[k, 0].float * ln(x1[k, 0] / x2[k, 0]).float
    return total.float


proc pairwise*[T: SomeNumber](X: Tensor[T], distance: (proc(x1, x2: Tensor[T], normalize: bool): float), normalize: bool = false): Tensor[float] =
    # Computes the pairwise distance of a 2D matrix across the selected distance
    let num_cols = X.shape[1]
    var dist = zeros[float](num_cols, num_cols)
    for i in 0||(num_cols-1):
        for j in 0..i:
            dist[i, j] = distance(X[0.._, i], X[0.._, j], normalize)
    return dist


proc symmetrize*(X: Tensor[SomeNumber], how: string = "l=>u"): Tensor[SomeNumber] = 
    # Mutates X symmetrical by copying upper triangle to lower triangle ("u=>l") or lower triangle to upper triangle ("l=>r")
    let num_rows = X.shape[0]
    let num_cols = X.shape[1]
    var X_copy = X
    if num_rows != num_cols:
        raise newException(ValueError, "Matrix must be symmetrical")
    if how != "l=>u" and how != "u=>l":
        raise newException(ValueError, "'how' must be one of 'l=>u' or 'u=>l'")
    if how == "l=>u":
        for i in 0..(num_cols-1):
            for j in 0..i:
                X_copy[j, i] = X[i, j]
    else:
        for i in 0..(num_cols-1):
            for j in 0..i:
                X_copy[i, j] = X[j, i]
    return X_copy


proc symmetrize*(X: var Tensor[SomeNumber], how: string = "l=>u"): Tensor[SomeNumber] = 
    # Mutates X symmetrical by copying upper triangle to lower triangle ("u=>l") or lower triangle to upper triangle ("l=>r")
    let num_rows = X.shape[0]
    let num_cols = X.shape[1]
    if num_rows != num_cols:
        raise newException(ValueError, "Matrix must be symmetrical")
    if how != "l=>u" and how != "u=>l":
        raise newException(ValueError, "'how' must be one of 'l=>u' or 'u=>l'")
    if how == "l=>u":
        for i in 0..(num_cols-1):
            for j in 0..i:
                X[j, i] = X[i, j]
    else:
        for i in 0..(num_cols-1):
            for j in 0..i:
                X[i, j] = X[j, i]
    return X