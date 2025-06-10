local grid = require("grid")
local funge = {}

CELL_WIDTH = 20
GRID_WIDTH = 20
GRID_HEIGHT = 20

function funge.initialize()
    funge.grid = grid:new(GRID_WIDTH, GRID_HEIGHT, nil)

    local w, h = love.graphics.getDimensions()
    funge.layout(w, h)
end

function funge.layout(w, h)
    funge.gridOrigin = {(w-GRID_WIDTH*CELL_WIDTH)/2, (h-GRID_HEIGHT*CELL_WIDTH)/2}
end

function funge.keyreleased(key, scancode)
end

function funge.mousemoved(x, y, dx, dy, istouch)
end

function funge.mousepressed(x, y, button, istouch, presses)
end

function funge.mousereleased(x, y, button, istouch, presses)
end

function funge.update(dt)
end

function funge.draw()
    for x, y, v in funge.grid:iterator() do
        love.graphics.rectangle("line",
            funge.gridOrigin[1]+(x-1)*CELL_WIDTH,
            funge.gridOrigin[2]+(y-1)*CELL_WIDTH,
            CELL_WIDTH,
            CELL_WIDTH)
    end
end

function funge.resize(w, h)
end

return funge
