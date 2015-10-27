import
    math, linalg

proc solveWithGauss[M, N](A: Matrix64[M, M], b: Vector64[N]): Vector64[M] =
    zeros(M)

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

