local M = {}

--[[
TODO:
    - location
]]

function M.load(world) 
    M.x = lg.getWidth() / 2
    M.y = lg.getHeight() / 2

    M.world = world;
    M.body = lp.newBody(world, M.x, M.y, "dynamic")
    M.shape = lp.newRectangleShape(64, 64)
    M.fixture = lp.newFixture(M.body, M.shape)

    return M
end

function M.draw()
    lg.rectangle("fill", M.body:getX(), M.body:getY(), 64, 64)
end

function M.update(dt)
    M.world:update(dt)

    if lk.isDown('w') then
        if M.body:getY() > 0 then
            M.body:applyLinearImpulse(0, -50)
        else
            M.body:setLinearVelocity(0, 0)
        end
    elseif lk.isDown('a') then
        if M.body:getX() > 0 then
            M.body:applyLinearImpulse(-50, 0)
        else
            M.body:setLinearVelocity(0, 0)
        end
    elseif lk.isDown('s') then
        if M.body:getY() < lg.getHeight() - 64 then
            M.body:applyLinearImpulse(0, 50)
        else
            M.body:setLinearVelocity(0, 0)
        end
    elseif lk.isDown('d') then
        if M.body:getX() < lg.getWidth() - 64 then
            M.body:applyLinearImpulse(50, 0)
        else
            M.body:setLinearVelocity(0, 0)
        end
    else
        M.body:setLinearVelocity(0, 0)
    end

end

return M