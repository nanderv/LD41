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
    for k,v in pairs(state.hand) do
        love.graphics.setColor(0, 0, 0)
        love.graphics.print(k..": "..scripts.gameobjects.cards[v].name, 200,568+k*20)
        love.graphics.setColor(1, 1, 1)
    end
end

R.drawCard = function(state, card)
    love.graphics.scale(math.min(love.graphics.getWidth() / (CAMERA.w * SCALING), love.graphics.getHeight() / (CAMERA.h * SCALING)))
    love.graphics.print(scripts.gameobjects.cards[state.hand[card]].name, 50,50)
end
return R