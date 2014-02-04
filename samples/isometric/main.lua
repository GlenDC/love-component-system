require 'lcs.engine'

-- Locals

local sprite_sheet = SPRITE_SHEET(love.graphics.newImage("data/tile_set.png"),64,64)

sprite_sheet:AddQuad("grass1",0,0,1,1)
sprite_sheet:AddQuad("grass2",1,0,1,1)
sprite_sheet:AddQuad("grass3",2,0,1,1)
sprite_sheet:AddQuad("grass4",3,0,1,1)
sprite_sheet:AddQuad("grass5",4,0,1,1)
sprite_sheet:AddQuad("grass6",5,0,1,1)
sprite_sheet:AddQuad("grass7",6,0,1,1)

sprite_sheet:AddQuad("block1",4,5,1,1)
sprite_sheet:AddQuad("block2",5,5,1,1)

sprite_sheet:AddQuad("blue",4,8,1,1)


local description = {
    World = {
        {
            Type = "SPRITE_BATCH",
            Properties = {
                SpriteSheet = sprite_sheet,
            }
        }
    },
    Camera = {
        {
            Type = "CAMERA",
            Properties = {}
        }
    },
    Cursor = {
        {
            Type = "SPRITE",
            Properties = {
                Texture = sprite_sheet.Source,
                Quad = sprite_sheet:GetQuad("blue"),
                Layer = 2,
                Color = {255,255,255,128}
            }
        }
    },
}

function CarToIso(x, y)
    return x - y, (x + y) / 2
end

function IsoToCar(i, j)
    return (i + 2*j) /2, (2*j - i )/2
end

local camera = ENTITY(description.Camera,{-400,-100})
local cursor = ENTITY(description.Cursor)
local cellsize = 32

-- Callbacks

function love.load()
    local world = ENTITY(description.World,{0,0})

    world:Bind()

    for x=0,400,cellsize do
        for y=0,400,cellsize do

            local q

            if math.random() > 0.06 then
                q = sprite_sheet:GetQuad("grass" .. math.random(1,7))
            else
                q = sprite_sheet:GetQuad("block" .. math.random(1,2))
            end

            world:AddSpriteQuad(q,CarToIso(x - cellsize*0.5,y - cellsize*0.5))
        end
    end

    world:Unbind()
end

function love.update(dt)
    ENGINE.Update(dt)

    if love.mouse.isDown('r') then
        local mx,my = love.mouse.getPosition()
        local dx,dy = mx - camera.MouseX, my - camera.MouseY

        camera.Position[1] = camera.Position[1] - dx
        camera.Position[2] = camera.Position[2] - dy

        camera.MouseX = mx
        camera.MouseY = my
    else
        camera.MouseX = love.mouse.getX()
        camera.MouseY = love.mouse.getY()
        cursor.Position[1] = camera.MouseX + camera.Position[1]
        cursor.Position[2] = camera.MouseY + camera.Position[2]

        local cx,cy = IsoToCar(cursor.Position[1], cursor.Position[2])

        cx = math.floor( cx / cellsize ) 
        cy = math.floor( cy / cellsize ) 

        cursor.Position = { CarToIso(cx * cellsize,cy * cellsize) }
    end
end

function love.draw()
    ENGINE.Render()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end
end