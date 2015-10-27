import sdl, graphics, colors

const
    # Window size
    width = 600
    height = 800
    
    zoom = 5
    lineColors = [ colRed, colGreen, colBlue ]
var 
    # Plotting parameters
    a: float
    b: float
    xoffset: float
    yoffset: float
    pointsForPlotting: int
    scale: float
    zoomed: bool

proc setDefaults() =
    a = -1.0
    b = 1.0
    xoffset = -a
    yoffset = -1.0
    pointsForPlotting = 600
    scale = width.float / (b - a)
    zoomed = false

proc convertCoords(x, y: float): graphics.TPoint = 
    result.x = ((x + xoffset) * scale).int
    result.y = (height - (y + yoffset) * scale).int

proc drawPlot(surf: graphics.PSurface, F: varargs[proc(x: float): float], assignyoffset: bool = false) = 
    var points: seq[float]
    points.newSeq(pointsForPlotting)
    for i in 0..pointsForPlotting-1:
        points[i] = a + i.float * (b - a) / (pointsForPlotting.float - 1)
    var fvalues: seq[seq[float]]
    fvalues.newSeq(F.len)
    for i in low(F)..high(F):
        fvalues[i].newSeq(pointsForPlotting)
        for j in 0..pointsForPlotting-1:
            fvalues[i][j] = F[i](points[j])
    
    if assignyoffset: 
        yoffset = -min(fvalues[0]) + 0.5
    
    surf.fillSurface(colWhite)

    # Axis
    if xoffset*scale >= 0 and xoffset*scale <= width:
        surf.drawVerLine((xoffset * scale).int, 0, height, colDarkGray)
    if yoffset*scale >= 0 and yoffset*scale <= height:
        surf.drawHorLine(0, (-yoffset * scale + height).int, width, colDarkGray)
    
    for i in low(F)..high(F):
        for j in 1..pointsForPlotting-1:
            surf.drawLine(convertCoords(points[j-1], fvalues[i][j-1]), convertCoords(points[j], fvalues[i][j]), lineColors[i %% lineColors.len])
    
    sdl.updateRect(surf.s, 0, 0, width, height)

proc showGraph*(F: varargs[proc(x: float): float]) = 
    setDefaults()
    
    var surf = newScreenSurface(width, height)
    surf.drawPlot(F, true)
    
    var 
        prevX = -1
        prevY = -1
        startX = -1
        startY = -1
    
    withEvents(surf, event):
        var eventp = addr(event)
        case event.kind:
        of sdl.QUITEV:
            break
        of sdl.MOUSEBUTTONDOWN:
            var mbd = sdl.evMouseButton(eventp)
            prevX = mbd.x.int
            startX = mbd.x.int
            prevY = mbd.y.int
            startY = mbd.y.int
        of sdl.MOUSEBUTTONUP:
            var 
                mbu = sdl.evMouseButton(eventp)
                x = mbu.x.int
                y = mbu.y.int
            if startX == x and startY == y:
                # Click
                if not zoomed:
                    zoomed = true
                    a = ((zoom + 1)*a + (zoom - 1)*b) / (2 * zoom)
                    b = ((zoom - 1)*a + (zoom + 1)*b) / (2 * zoom)
                    xoffset = -a
                    scale = width.float / (b - a)
                else:
                    zoomed = false
                    #a = ((zoom + 1)*a + (-zoom + 1)*b) / 2
                    #b = ((-zoom + 1)*a + (zoom + 1)*b) / 2
                    a = -1.0
                    b = 1.0
                    xoffset = -a
                    scale = width.float / (b - a)
                surf.drawPlot(F)
            prevX = -1
            prevY = -1
        of sdl.MOUSEMOTION:
            var 
                mm = sdl.evMouseMotion(eventp)
                x = mm.x.int
                y = mm.y.int
            if prevX >= 0 and prevY >= 0:
                var 
                    shiftX = x - prevX
                    shiftY = y - prevY
                a = a - shiftX.float / scale
                b = b - shiftX.float / scale
                xoffset = -a
                yoffset = yoffset - shiftY.float / scale
                surf.drawPlot(F)
                
                prevX = x
                prevY = y
        else: discard
        
        sdl.updateRect(surf.s, 0, 0, width, height)

