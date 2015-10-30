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
    if n == 0:
        return 1
    elif n == 1:
        return x
    else:
        return ((2*n - 1).float * x * Lp(n - 1, x) - (n - 1).float * Lp(n - 2, x)) / n.float

proc integral(f: (proc(x: float): float), a, b: float): float =
    const n = 1e6
    var xn = a + (b - a) / (2*n)
    while xn < b:
        result += f(xn) * (b - a) / n
        xn += (b - a) / n

proc legendrePolynomialsApproximation*(f: (proc(x: float): float), a, b: float): (proc(x:float): float) =
    const degree = 3
    let c = makeVector(degree, proc(i: int): float64 =
        integral(proc(x: float): float = f(x) * Lp(i + 1, x), a, b) / integral(proc(x: float): float = pow(Lp(i + 1, x), 2), a, b))
    echo c
    return proc(x: float): float =
        for i in 0..(degree - 1):
            result += c[i] * Lp(i + 1, x)

