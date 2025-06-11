local grid = require("grid")
local funge = {}

CELL_WIDTH = 20
GRID_WIDTH = 20
GRID_HEIGHT = 20

function funge.initialize()
    funge.grid = grid:new(GRID_WIDTH, GRID_HEIGHT, nil)

    local w, h = love.graphics.getDimensions()
    funge.layout(w, h)

    funge.mouseLocation = nil
end

function funge.layout(w, h)
    funge.gridOrigin = { (w - GRID_WIDTH * CELL_WIDTH) / 2, (h - GRID_HEIGHT * CELL_WIDTH) / 2 }
end

function funge.keyreleased(key, scancode)
end

function funge.mousemoved(x, y, dx, dy, istouch)
    funge.setMouseLocation(x, y)
end

function funge.mousepressed(x, y, button, istouch, presses)
    funge.setMouseLocation(x, y)
end

function funge.mousereleased(x, y, button, istouch, presses)
    funge.setMouseLocation(x, y)
end

function funge.update(dt)
end

function funge.draw()
    local fg = { love.math.colorFromBytes(255, 255, 255) }
    local bg = { love.math.colorFromBytes(0, 0, 0) }
    for x, y, v in funge.grid:iterator() do
        local f, b
        if funge.mouseLocation ~= nil and
            x == funge.mouseLocation[1] and y == funge.mouseLocation[2] then
            f, b = bg, fg
        else
            f, b = fg, bg
        end
        love.graphics.setColor(b)
        love.graphics.rectangle("fill",
            funge.gridOrigin[1] + (x - 1) * CELL_WIDTH,
            funge.gridOrigin[2] + (y - 1) * CELL_WIDTH,
            CELL_WIDTH,
            CELL_WIDTH)
        love.graphics.setColor(f)
        love.graphics.rectangle("line",
            funge.gridOrigin[1] + (x - 1) * CELL_WIDTH,
            funge.gridOrigin[2] + (y - 1) * CELL_WIDTH,
            CELL_WIDTH,
            CELL_WIDTH)
    end
end

function funge.resize(w, h)
    funge.layout(w, h)
end

function funge.setMouseLocation(x, y)
    local xx = math.floor((x - funge.gridOrigin[1]) / CELL_WIDTH) + 1
    local yy = math.floor((y - funge.gridOrigin[2]) / CELL_WIDTH) + 1
    if funge.grid:inBounds(xx, yy) then
        funge.mouseLocation = { xx, yy }
    else
        funge.mouseLocation = nil
    end
end

return funge
