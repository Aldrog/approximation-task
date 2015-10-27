import
    approximation,
    function,
    plotter,
    math, linalg

const
    nodeCount = 5
    aStart = -1.0
    aEnd = 1.0
    
    source: (proc(x: float): float) = f

proc eqnodes(): Vector64[nodeCount] =
    new result
    for i in 0..(nodeCount - 1):
        result[i] = aStart + i.float * (aEnd - aStart) / (nodeCount - 1)

proc values[N: static[int]](function: (proc(x: float): float), x: Vector64[N]): Vector64[N] =
    new result
    for i in 0..(N - 1):
        result[i] = function(x[i])

let
    x = eqnodes()
    #x = vector([-1.0, -0.5, 0.0, 0.5, 1.0])
    y = source.values(x)

let approx: (proc(x: float): float) = leastSquares(x, y)

showGraph(@[source, approx])

