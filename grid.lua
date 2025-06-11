local grid = {}
grid.__index = grid

function grid:new(width, height, default)
    local g = {}
    setmetatable(g, grid)
    g.width = width
    g.height = height
    g.data = {}
    for _ = 1, height * width do
        table.insert(g.data, default)
    end

    return g
end

function grid:newFunc(width, height, f)
    local g = {}
    setmetatable(g, grid)
    g.width = width
    g.height = height
    g.data = {}
    for r = 1, height do
        for c = 1, width do
            table.insert(g.data, f(r, c))
        end
    end

    return g
end

function grid:inBounds(x, y)
    return x >= 1 and y >= 1 and x <= self.width and y <= self.height
end

function grid:get(x, y)
    if not self:inBounds(x, y) then return nil end
    return self.data[x + self.width * y]
end

function grid:set(x, y, v)
    if not self:inBounds(x, y) then return end
    self.data[x + self.width * y] = v
end

function grid:getUnsafe(x, y)
    return self.data[x + self.width * y]
end

function grid:iterator()
    local co = coroutine.create(function()
        for y = 1, self.height do
            for x = 1, self.width do
                coroutine.yield(x, y, self.data[x + self.width * y])
            end
        end
    end)
    return function()
        local _, x, y, v = coroutine.resume(co)
        return x, y, v
    end
end

function grid:neighborhood(x, y, radius, exclusive)
    local co = coroutine.create(function()
        local xmin, xmax = math.max(1, x - radius), math.min(self.width, x + radius)
        local ymin, ymax = math.max(1, y - radius), math.min(self.height, y + radius)
        for yy = ymin, ymax do
            for xx = xmin, xmax do
                if x ~= xx or y ~= yy or (not exclusive) then
                    coroutine.yield(xx, yy, self.data[xx + self.width * yy])
                end
            end
        end
    end)
    return function()
        local _, xx, yy, v = coroutine.resume(co)
        return xx, yy, v
    end
end

return grid
