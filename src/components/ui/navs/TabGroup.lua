local super = require "src.components.ui.GroupUIComponent"
local M = setmetatable({}, { __index = super })
M.__index = M
M.__file = __file__()

function M.new(type)
    local self = setmetatable(lume.extend(super.new(type), {
        tabRow = super.new(),
        selectedTabIndex = 1,
        tabs = {},
        tabIds = {},
        tabHighlightColor = {
            r = 0.47,
            g = 0.75,
            b = 0.78,
            a = 1
        },
        tabHighlightPadding = {
            x = 4,
            y = 4,
        }
    }), M)
    self.tabRow.direction = 'horizontal'
    --self.tabRow.justify = 'center' -- currently doesn't work
    self.tabRow.bgColor = {
        r = 0,
        g = 1,
        b = 0,
        a = 1
    }
    self.bgColor = {
        r = 0,
        g = 0,
        b = 1,
        a = 1
    }
    self:addUiElement(self.tabRow)
	return self
end

function M:selectTab(id)
    local previousTabIndex = self.selectedTabIndex
    self.selectedTabIndex = nil
    if type(id) == 'string' then
        self.selectedTabIndex = self.tabIds[id]
        if self.selectedTabIndex == nil then
            error ('could not find tab id ' .. id .. ' (ids: ' .. inspect(lume.keys(self.tabIds)) .. ')')
        else
            self:removeUiElement(self.tabs[previousTabIndex])
            self:addUiElement(self.tabs[self.selectedTabIndex])

            self.tabRow.uielements[previousTabIndex].bgColor = nil
            self:highlightSelectedTab()
        end
    else
        error 'invalid type for tab id'
    end
end

function M:currentTab()
    if type(self.selectedTabIndex) == 'string' then
        return self.tabs[self.tabIds[self.selectedTabIndex]]
    else
        return self.tabs[self.selectedTabIndex]
    end
end

function M:addTab(id, view)
    table.insert(self.tabs, view)
    self.tabIds[id] = #self.tabs
    self.tabRow:addButton(view.title, events.ui.TabSelectedEvent.new(id, self))
    if #self.tabs == 1 then
        self:addUiElement(view)
        self:highlightSelectedTab()
    end
end

function M:highlightSelectedTab()
    self.tabRow.uielements[self.selectedTabIndex].bgColor = self.tabHighlightColor
end

return M