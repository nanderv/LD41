--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 17:19
-- To change this template use File | Settings | File Templates.
--

local R = {}

R.renderBackdrop = function()
    -- Draw top bar
    love.graphics.rectangle("fill", 0, 0, 1366, 30)

    -- Draw bottom UI component
    love.graphics.rectangle("fill", 0, 568, 1366, 200)
    love.graphics.rectangle("fill", -1000, 0, 1000, 1000)

    -- Sharply cut off sides of screen
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle("fill", 1366, 0, 2000, 1000)
    love.graphics.rectangle("fill", 0, 768, 2000, 1000)
    love.graphics.setColor(1, 1, 1)
end

R.drawCards = function(state, lowest)
    love.graphics.setColor(1,0,0)
    love.graphics.rectangle("fill", 150, 568, 100,300 )
    love.graphics.rectangle("fill", 1100, 568, 100,300 )
    for k, v in pairs(state.hand) do
        if not (k <= lowest) and not (k > (lowest + 4)) then
            love.graphics.setColor(0, 0, 0)
            scripts.rendering.renderCard.renderCard(scripts.gameobjects.cards[v], 100 + (k-lowest) * 200, 568, 0.8)
            love.graphics.setColor(1, 1, 1)
        end
    end
end

R.drawCard = function(state, card, running)
    if running then
        scripts.rendering.renderCard.renderCard(scripts.gameobjects.cards[state.hand[card]], 50,50, 0.5)
    else
        scripts.rendering.renderCard.renderCard(scripts.gameobjects.cards[state.hand[card]], 500,100, 1.5)
    end
end
R.drawMessage = function(message)
    love.graphics.rectangle("fill", 300, 538, 766, 30)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print(message, 330, 548)
    love.graphics.setColor(1, 1, 1)

end
R.drawStats = function(state)
    local gamerules = scripts.helpers.gamerules
    love.graphics.getFont():setFilter("linear", "linear")
    love.graphics.setColor(0, 0, 0)
    love.graphics.print("Population: " .. state.properties.population, 200, 7)
    love.graphics.print("Available housing: " .. gamerules.getAvailableHousing(state), 400, 7)
    love.graphics.print("Happiness: " .. gamerules.getHappiness(state), 600, 7)
    love.graphics.print("Leftover work: " .. gamerules.getAvailableWork(state), 800, 7)
    love.graphics.print("Power: " .. gamerules.getExcessPower(state), 1000, 7)
    love.graphics.setColor(1, 1, 1)
    love.graphics.setDefaultFilter("nearest", "nearest")
end
return R