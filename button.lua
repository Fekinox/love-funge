local aabb = require("aabb")

BUTTON_FOREGROUND = { love.math.colorFromBytes(255, 255, 255) }
BUTTON_BACKGROUND = { love.math.colorFromBytes(0, 0, 0) }

local button = {}
button.__index = button

function button:new(width, height, text, cb)
    local b = {}
    setmetatable(b, button)
    b.callback = cb
    b.hover = false
    b.down = false
    b.width, b.height, b.text = width, height, text
    return b
end

function button:layout(x, y)
    self.posX = x
    self.posY = y
end

function button:update(dt)
    local mx, my = love.mouse.getPosition()
    if aabb.contains({
            self.posX,
            self.posY,
            self.width,
            self.height
        }, { mx, my }) then
        self.hover = true
        if self.down and not love.mouse.isDown(1) then
            self.callback()
        end
        self.down = love.mouse.isDown(1)
    else
        self.hover = false
        self.down = false
    end
end

function button:draw()
    local f, b = BUTTON_FOREGROUND, BUTTON_BACKGROUND
    if self.hover then
        f, b = b, f
    end
    love.graphics.setColor(b)
    love.graphics.rectangle("fill", self.posX, self.posY, self.width, self.height)
    love.graphics.setColor(f)
    love.graphics.rectangle("line", self.posX, self.posY, self.width, self.height)
    love.graphics.print(self.text, self.posX, self.posY)
end

return button
