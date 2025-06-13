local widgetGroup = {}
widgetGroup.__index = widgetGroup

function widgetGroup:new()
    local w = {}
    setmetatable(w, widgetGroup)
    w.widgets = {}
    return w
end

function widgetGroup:add(wd)
    table.insert(self.widgets, wd)
end

function widgetGroup:update(dt)
    for _, wd in self.widgets do
        wd:update(dt)
    end
end

function widgetGroup:draw()
    for _, wd in self.widgets do
        wd:draw()
    end
end
