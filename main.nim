import
    approximation,
    function,
    plotter,
    math, linalg

const
    nodeCount = 5
    aStart = -1.0
    aEnd = 1.0
    
proc eqnodes(N: static[int]): Vector64[N] =
    new result
    for i in 0..(N - 1):
        result[i] = aStart + i.float * (aEnd - aStart) / (N - 1)

proc values[N](function: (proc(x: float): float), points: Vector64[N]): Vector64[N] =
    new result
    for i in 0..(N - 1):
        result[i] = function(points[i])

let
    x = eqnodes(nodeCount)
    #x = vector([-1.0, -0.5, 0.0, 0.5, 1.0])
    y = f.values(x)

let 
    source: (proc(x: float): float) = f
    leastSquaresApproximation: (proc(x: float): float) = leastSquares(x, y)
    legendreApproximation: (proc(x: float): float) = ortogonalPolinomials(f, aStart, aEnd)

showPlot(source, leastSquaresApproximation, legendreApproximation)

