local button = {}
button.__index = button

function button:new(cb)
    local b = {}
    setmetatable(b, button)
    b.callback = cb
    return b
end

function button:draw(x, y)
end

return button
