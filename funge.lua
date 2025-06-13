local grid = require("grid")
local button = require("button")
local programState = require("programState")

local funge = {}

CELL_WIDTH = 20
GRID_WIDTH = 20
GRID_HEIGHT = 20

SIMULATION_SPEED = 0.1

function funge.initialize()
    funge.grid = grid:new(GRID_WIDTH, GRID_HEIGHT, nil)


    funge.mouseLocation = nil
    funge.character = nil

    funge.startButton = button:new(100, 40, "start", funge.startProgram)
    funge.stepButton = button:new(100, 40, "step", funge.stepProgram)
    funge.pauseButton = button:new(100, 40, "pause", funge.pauseProgram)

    funge.progState = nil

    local w, h = love.graphics.getDimensions()
    funge.layout(w, h)
end

function funge.layout(w, h)
    funge.gridOrigin = { (w - GRID_WIDTH * CELL_WIDTH) / 2, (h - GRID_HEIGHT * CELL_WIDTH) / 2 }
    funge.buttonOrigin = { funge.gridOrigin[1], funge.gridOrigin[2] - 50 }
    funge.startButton:layout(funge.buttonOrigin[1], funge.buttonOrigin[2])
    funge.stepButton:layout(funge.buttonOrigin[1] + 120, funge.buttonOrigin[2])
    funge.pauseButton:layout(funge.buttonOrigin[1] + 240, funge.buttonOrigin[2])
end

function funge.textinput(text)
    if text == " " then
        funge.character = nil
    end
    funge.character = text
end

function funge.keypressed(key, scancode)
end

function funge.keyreleased(key, scancode)
end

function funge.mousemoved(x, y, dx, dy, istouch)
    funge.setMouseLocation(x, y)
    if funge.progState == nil and funge.mouseLocation ~= nil and love.mouse.isDown(1) then
        funge.grid:set(funge.mouseLocation[1], funge.mouseLocation[2], funge.character)
    end
end

function funge.mousepressed(x, y, button, istouch, presses)
    funge.setMouseLocation(x, y)
    if funge.progState == nil and funge.mouseLocation ~= nil then
        funge.grid:set(funge.mouseLocation[1], funge.mouseLocation[2], funge.character)
    end
end

function funge.mousereleased(x, y, button, istouch, presses)
    funge.setMouseLocation(x, y)
end

function funge.startProgram()
    if funge.progState == nil then
        funge.progState = {
            active = true,
            timer = 0,

            state = programState:new()
        }
    else
        funge.progState = nil
    end
end

function funge.update(dt)
    funge.startButton:update(dt)
    funge.stepButton:update(dt)
    funge.pauseButton:update(dt)

    if funge.progState ~= nil and funge.progState.active then
        funge.progState.timer = funge.progState.timer + dt
        while funge.progState.timer > SIMULATION_SPEED do
            funge.progState.state:update(funge.grid)
            funge.progState.timer = funge.progState.timer - SIMULATION_SPEED
        end
    end
end

function funge.draw()
    local fg = { love.math.colorFromBytes(255, 255, 255) }
    local bg = { love.math.colorFromBytes(0, 0, 0) }
    for x, y, v in funge.grid:iterator() do
        local f, b, hl
        if funge.progState == nil and funge.mouseLocation ~= nil and
            x == funge.mouseLocation[1] and y == funge.mouseLocation[2] then
            f, b = bg, fg
            hl = true
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
        if v then
            love.graphics.print(v,
                funge.gridOrigin[1] + (x - 1) * CELL_WIDTH,
                funge.gridOrigin[2] + (y - 1) * CELL_WIDTH)
        elseif hl and funge.character then
            love.graphics.print(funge.character,
                funge.gridOrigin[1] + (x - 1) * CELL_WIDTH,
                funge.gridOrigin[2] + (y - 1) * CELL_WIDTH)
        end
    end

    -- Buttons
    funge.startButton:draw()
    funge.stepButton:draw()
    funge.pauseButton:draw()

    -- Cursor
    if funge.progState ~= nil then
        local xx, yy = funge.progState.state.x, funge.progState.state.y
        love.graphics.rectangle("line",
            funge.gridOrigin[1] + (xx - 1) * CELL_WIDTH - 5,
            funge.gridOrigin[2] + (yy - 1) * CELL_WIDTH - 5,
            CELL_WIDTH + 10,
            CELL_WIDTH + 10)
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
