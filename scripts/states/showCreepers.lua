local menu = {} -- previously: Gamestate.new()
function menu:enter(prev, cards)
    menu.prev = prev
    menu.cards = cards
end

local offsets = {
    { x = 621, y = 153 },
    { x = 373, y = 153 },
    { x = 869, y = 153 },
    { x = 124, y = 153 },
    { x = 1118, y = 153 },

    { x = 621, y = 460 },
    { x = 373, y = 460 },
    { x = 869, y = 460 },
    { x = 124, y = 460 },
    { x = 1118, y = 460 },
}

function menu:draw()
    menu.prev:draw()
    for i = 1, math.min(#offsets, #menu.cards) do
        scripts.rendering.renderCard.renderCard(menu.cards[i], offsets[i].x, offsets[i].y, 0.5)
    end
end

function menu:mousepressed(x, y, click)
    for i = 1, math.min(#offsets, #menu.cards) do
        for k, card in pairs(scripts.gameobjects.cards) do
            if menu.cards[i] == card then
                STATE.discardPile[#STATE.discardPile + 1] = k
            end
        end
    end
    Gamestate.pop()
end

return menu