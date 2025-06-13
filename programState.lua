local programState = {}
programState.__index = programState

function programState:new()
    local s = {}
    setmetatable(s, programState)
    s.x = 1
    s.y = 1
    s.dx = 1
    s.dy = 0
    return s
end

function programState:update(program)
    local v = program:getUnsafe(self.x, self.y)

    if v == "v" then
        self.dx, self.dy = 0, 1
    elseif v == "<" then
        self.dx, self.dy = -1, 0
    elseif v == ">" then
        self.dx, self.dy = 1, 0
    elseif v == "^" then
        self.dx, self.dy = 0, -1
    end

    self.x = self.x + self.dx
    self.y = self.y + self.dy

    if self.x < 1 then
        self.x = program.width
    end
    if self.x > program.width then
        self.x = 1
    end
    if self.y < 1 then
        self.y = program.height
    end
    if self.y > program.height then
        self.y = 1
    end
end

return programState
