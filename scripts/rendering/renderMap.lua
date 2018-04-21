--
-- Created by IntelliJ IDEA.
-- User: nander
-- Date: 21/04/2018
-- Time: 14:18
-- To change this template use File | Settings | File Templates.
--

GFX = {}

CAMERA = {x=0,y=0,r=0, w=love.graphics.getWidth()/1.5,h=love.graphics.getHeight()/1.5 }

function DRAWMAP(objects)
    local renderByLayers = {}
    local max = 0
    local min = 1000
    for k,v in pairs(objects) do
        renderByLayers[v.position.z] =renderByLayers[v.position.z] or {}
        renderByLayers[v.position.z][#renderByLayers[v.position.z]+1] = v
        max = math.max(v.position.z, max+GFX[v.texture].slides)
        min = math.min(v.position.z, min)
    end
    local renderObjs = {}
    for i=min, max do
        atlas.spritebatch:clear()

        if(renderByLayers[i]) then
            for k,v in ipairs(renderByLayers[i]) do
                renderObjs[v] = v
            end
        end
        for k,v in pairs(renderObjs) do
            if i >= GFX[v.texture].slides + v.position.z then
                renderObjs[k] = nil
            else
                GFX[v.texture]:draw(v.position.x, v.position.y, v.position.z, i-v.position.z, v.position.r, atlas.spritebatch)
            end
        end
        love.graphics.draw(atlas.spritebatch, 0, 0)
    end
end
local function addQuads(format)
    format.quads = {}
    format.sizeX = format.image:getWidth()/format.slides
    format.sizeY = format.image:getHeight()
    for i=1, format.slides do
        format.quads[#format.quads+1] = love.graphics.newQuad((i-1)*format.image:getWidth()/format.slides+format.UV.x, format.UV.y, format.image:getWidth()/format.slides, format.image:getHeight(), atlas.map:getWidth(), atlas.map:getHeight())
    end
end
local function draw(self, x,y, z,layer, r, batch)
    local i = layer+1
    local XX= x*math.cos(CAMERA.r)+  y*math.sin(CAMERA.r)
    local YY=  - x*math.sin(CAMERA.r) +  y*math.cos(CAMERA.r)
    batch:add(self.quads[i], -CAMERA.x +XX+ 0.5*CAMERA.w,-CAMERA.y+ YY -i-z + 0.5*CAMERA.h,r-CAMERA.r,1,1,self.sizeX/2, self.sizeY/2)
end
return function()
    local f = require 'assets.25d.formats'
    for _, format in ipairs(f) do
        GFX[format.key] = format
        format.image = love.graphics.newImage("assets/25d/"..format.file)
        format.addQuads = addQuads
        format.draw = draw
    end
end