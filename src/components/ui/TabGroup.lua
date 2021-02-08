local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M

function M.new(type)
    local self = setmetatable(super.new(type), M)
    self.direction = 'horizontal'
    self.selectedTabIndex = 1
    self.tabs = {}
	return self
end

function M:draw()
    super.draw(self)
    if self.selectedTabIndex ~= nil then
        lg.push()
        lg.translate(0, 100)
        self.tabs[self.selectedTabIndex]:draw()
        lg.pop()
    end
end

function M:update(dt)
    super.update(self, dt)
    if self.selectedTabIndex ~= nil then
        self.tabs[self.selectedTabIndex]:update(dt)
    end
end

function M:selectTab(id)
    self.selectedTabIndex = nil
    for i,t in ipairs(self.tabs) do
        if t.id == id then
            self.selectedTabIndex = i
            break
        end
    end
end

function M:addTab(id, view)
    --local t = uiComponents.TabItem.new(id, view)
    --t:addUiComponent(view)
    --table.insert(self.tabs, t)
    table.insert(self.tabs, view)

    self:addButton(view.title, TabSelectedEvent.new(id, self))
    return t
end

return M