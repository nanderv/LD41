--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 17:19
-- To change this template use File | Settings | File Templates.
--

local R = {}

R.renderBackdrop = function()
    love.graphics.rectangle("fill", 0, 568, 1366, 200)
    love.graphics.rectangle("fill", -1000, 0, 1000, 1000)
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 1366, 0, 2000, 1000)
    love.graphics.rectangle("fill", 0, 768, 2000, 1000)
    love.graphics.setColor(1, 1, 1)
end

R.drawCards = function(state)
    for k,v in ipairs(state.hand) do
        print(scripts.gameobjects.cards[v].name)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(k..": "..scripts.gameobjects.cards[v].name, 200,568+k*20)
        love.graphics.setColor(1, 1, 1)
    end
end
return R