ICONS = ICONS or {}

return function()
    local f = require 'assets.icons'
    for _, format in ipairs(f) do
        ICONS[format.key] = format
        format.image = love.graphics.newImage("assets/"..format.file)
    end
end
