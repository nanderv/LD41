--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 17:19
-- To change this template use File | Settings | File Templates.
--

local R = {}

R.renderCard = function(card, x, y, scale)
    love.graphics.setDefaultFilter("linear", "linear", 2)

    love.graphics.push()
    love.graphics.scale(scale)
    love.graphics.setColor(0.8,0.8,0.8)
    love.graphics.rectangle("fill", x/scale,y/scale, 200, 300)
    love.graphics.setColor(0,0,0)
    love.graphics.print(card.name, x/scale+20,y/scale+20)

    love.graphics.pop()
    love.graphics.setColor(1,1,1)
    love.graphics.setDefaultFilter("nearest", "nearest")

end
return R