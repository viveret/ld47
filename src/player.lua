local M = {}

--[[
TODO:
    - location
]]

function M.load() 
    M.x = lg.getWidth() / 2
    M.y = lg.getHeight() / 2
    M.speed = 16

    return M
end

function M.draw()
    lg.rectangle("fill", M.x, M.y, 64, 64)
end

function M.update()
    if lk.isDown('w') then
        if M.y > 0 then
            M.y = M.y - M.speed
        end
    elseif lk.isDown('a') then
        if M.x > 0 then
            M.x = M.x - M.speed
        end
    elseif lk.isDown('s') then
        if M.y < lg.getHeight() - 64 then
            M.y = M.y + M.speed
        end
    elseif lk.isDown('d') then
        if M.x < lg.getWidth() - 64 then
            M.x = M.x + M.speed
        end
    end
end

return M