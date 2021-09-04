local M = {}
M.__index = M
M.__file = __file__()

function M.new(scene)
    if scene == nil or scene == '' then
        error('scene cannot be nil or empty')
    end
    local self = setmetatable({
        scene = scene,
        state = {
            
        },
        states = {},
	}, M)
	return self
end

function M:onTypeReloaded()
    -- self:
end

function M:draw()
end

function M:tick(ticks)
end

function M:update(dt)
end

function M:save()
end

function M:load()
end

function M:quicksave()
    table.push(self.states, lume.extend({}, self.state))
end

function M:quickload(state)
    if state == nil then
    elseif state < 0 then
    else
    end
end

function M:reload()
    self:quickload(self.initialState)
end

function M:switchTo(x, y)
end

function M:activated()
end

return M