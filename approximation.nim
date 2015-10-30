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
        # basis of approximation space
        phi =  [(proc(x: float): float = pow(x, 3.0)),
                (proc(x: float): float = pow(x, 2.0)),
                (proc(x: float): float = pow(x, 1.0))]

        Q = makeMatrix(N, len(phi), proc(i, j: int): float = phi[j](x[i]))
        # a (vector of coefficients) should satisfy Q.t*Q*a = Q.t*y
        a = solveWithGauss(Q.t * Q, Q.t * y)

    return proc(x: float): float =
        for i in low(phi)..high(phi):
            result += a[i] * phi[i](x)

proc Lp(n: int, x: float): float =
    for i in 0..n:
        if i mod 2 == 0:
            result += binom(n, i).float * 2*i.float * pow(x, (2*i - n).float)
        else:
            result -= binom(n, i).float * 2*i.float * pow(x, (2*i - n).float)
    result *= 1 / (fac(n)*(2^n))

proc legendrePolynomialsApproximation*(f: (proc(x: float): float)): (proc(x:float): float) =
    return proc(x: float): float = 0

