local funge = require("funge")

function love.load()
    funge.initialize()
end

function love.textinput(text)
    funge.textinput(text)
end

function love.keypressed(key, scancode)
    funge.keypressed(key, scancode)
end

function love.keyreleased(key, scancode)
    funge.keyreleased(key, scancode)
end

function love.mousemoved(x, y, dx, dy, istouch)
    funge.mousemoved(x, y, dx, dy, istouch)
end

function love.mousepressed(x, y, button, istouch, presses)
    funge.mousepressed(x, y, button, istouch, presses)
end

function love.mousereleased(x, y, button, istouch, presses)
    funge.mousereleased(x, y, button, istouch, presses)
end

function love.update(dt)
    funge.update(dt)
end

function love.draw()
    funge.draw()
end

function love.resize(w, h)
    funge.resize(w, h)
end
