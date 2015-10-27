import
    math, linalg

proc solveWithGauss[M, N](A: Matrix64[M, N], b: Vector64[M]): Vector64[N] =
    var expandedMatrix = makeMatrix(M, N + 1,
        proc(i, j: int): float = (if j < N: A[i, j] else: b[i]),
        order = rowMajor)
    echo expandedMatrix
    var emRows: array[M, Vector64[N + 1]]
    for i in 0..(M - 1):
        emRows[i] = expandedMatrix.rowUnsafe(i)

    for i in 0..(M - 2):
        for j in (i + 1)..(M - 1):
            emRows[j] -= emRows[i] * (emRows[j][i] / emRows[i][i])
    echo expandedMatrix
    for i in countdown(M - 1, 1):
        for j in 0..(i - 1):
            emRows[j] -= emRows[i] * (emRows[j][i] / emRows[i][i])
    echo expandedMatrix
    for i in 0..(M - 1):
        emRows[i] /= emRows[i][i]
    echo expandedMatrix
    return expandedMatrix.column(N)

proc leastSquares*[N](x: Vector64[N], y: Vector64[N]): (proc(x: float): float) =
    let 
        phi =  [(proc(x: float): float = pow(x, 3.0)),
                (proc(x: float): float = pow(x, 2.0)),
                (proc(x: float): float = pow(x, 1.0))]

        Q = makeMatrix(N, len(phi), proc(i, j: int): float = phi[j](x[i]))
        a = solveWithGauss(Q.t * Q, Q.t * y)

    return proc(x: float): float =
        for i in low(phi)..high(phi):
            result += a[i] * phi[i](x)

