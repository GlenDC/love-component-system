require 'lcs.engine'

require 'game'

local game = GAME()

function love.load(arg)
    love.graphics.setBackgroundColor( 0, 255, 255 )
    ENGINE.Initialize(arg)
    game:Load()
    game:NewGame()
end

function love.update(dt)
    game:Update(dt)
    ENGINE.Update(dt)
end

function love.draw()
    ENGINE.Render()
end

function love.keypressed(key)
    if key == "escape" then
        love.event.push("quit")
    end

    if key == "f1" then
        game:NewGame()
    end
end