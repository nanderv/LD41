--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 17:19
-- To change this template use File | Settings | File Templates.
--

local R = {}
local font = love.graphics.newFont( 20 )
R.renderCard = function(card, x, y, scale)

    love.graphics.setDefaultFilter("linear", "linear", 2)

    love.graphics.push()
    love.graphics.scale(scale)

    love.graphics.setColor(0.8,0.8,0.8)

    love.graphics.rectangle("fill", x/scale,y/scale, 300, 400)
    love.graphics.setColor(0,0,0)
    local pfont =  love.graphics.getFont( )
    love.graphics.setFont(font)

    if card.costs and card.costs.value then
        love.graphics.setColor(1,1,1)
        if card.costs.type =="money" then
            love.graphics.draw(ICONS["field-money"].image, x/scale, y/scale,0,0.2)
        end
        if card.costs and card.costs.type =="population" then
            love.graphics.draw(ICONS["population"].image, x/scale, y/scale,0,0.2)
        end
        if card.costs and card.costs.type =="happiness" then
            love.graphics.draw(ICONS["happiness"].image, x/scale, y/scale,0,0.2)
        end

        love.graphics.print(card.costs.value, 20+x/scale+15,y/scale+8)
    end
    love.graphics.setColor(0,0,0)

    love.graphics.print(card.name, x/scale+80,y/scale+5)
    love.graphics.pop()
    love.graphics.setColor(1,1,1)
    love.graphics.setDefaultFilter("nearest", "nearest")
    love.graphics.setFont(pfont)


end
return R