require 'level'
require 'component_cannon'

GAME = class(function(o)
    o.MouseIsDown = {}
    o.MouseIsJustDown = {}
    o.PreviousMouseIsDown = {}
    o.PreviousMousePosition = nil
    o.MouseWorldPosition = {}
    o.Level = LEVEL()

    GAME.Instance = o
end)

STATE_MACHINE.ImplementInClass(GAME)

local title_font, font

function GAME:Load()
    TEXTURE.Load("cloud","data/cloud.png")
    TEXTURE.Load("crate1","data/crate1.png")
    TEXTURE.Load("crate2","data/crate2.png")
    TEXTURE.Load("crate3","data/crate3.png")
    TEXTURE.Load("ball","data/ball.png")

    title_font = love.graphics.newFont("data/game_boy.ttf",72)
    font = love.graphics.newFont("data/game_boy.ttf",24)
end

function GAME:NewGame()
    ENTITY.DestroyAll()
    self.Level:Load()
    self.Camera = ENTITY({
        {
            Type = "CAMERA",
            Properties = {
            }
        }
    })

    self.Cannon = ENTITY({
        {
            Type = "SPRITE",
            Properties = {
                Texture = TEXTURE.Get("ball"),
                Extent = {16,64}
            }
        },
        {
            Type = "CANNON",
            Properties = {
            }
        }
    }, {20, 500})
end

function GAME:Update(dt)
    self:UpdateInput()

    local cursor_position = {love.mouse.getPosition()}

    if self.MouseIsDown[2] then
        local delta = {cursor_position[1] - self.PreviousMousePosition[1], cursor_position[2] - self.PreviousMousePosition[2]}
        self.Camera.Position[1] = self.Camera.Position[1] - delta[1]
        self.Camera.Position[2] = self.Camera.Position[2] - delta[2]
    end

    self.MouseWorldPosition = {self.Camera.Position[1] + cursor_position[1], self.Camera.Position[2] + cursor_position[2]}

    if self.MouseIsJustDown[1] then
        --self:SpawnBall(self.MouseWorldPosition)

        self.Cannon:Shoot()
    end

    self:UpdateState(dt)
    self.PreviousMousePosition = cursor_position

end

function GAME.OnStateEnter:Menu()
    self:NewGame()
end

function GAME.OnStateUpdate:Menu(dt)

    if self.MouseIsJustDown then
        self:ChangeState("InGame")
    end
end

function GAME.OnStateExit:Menu()

end

function GAME.OnStateEnter:InGame()


end

function GAME.OnStateUpdate:InGame(dt)

end

function GAME.OnStateUpdate:GameOver(dt)

end

function GAME:GameOver()

end

function GAME:UpdateInput()
    self.MouseIsDown[1] = love.mouse.isDown('l')
    self.MouseIsDown[2] = love.mouse.isDown('r')
    for i=1,2 do
        if self.MouseIsDown[i] and not self.PreviousMouseIsDown[i] then
            self.MouseIsJustDown[i] = true
        else
            self.MouseIsJustDown[i] = false
        end

        self.PreviousMouseIsDown[i] = self.MouseIsDown[i]
    end
end

function GAME:SpawnBall(pos)
    return ENTITY({
        {
            Type = "PHYSIC",
            Properties = {
                Shape = "circle",
                Radius = 7,
                Type = "dynamic",
                Density = 1000
            }
        },
        {
            Type = "SPRITE",
            Properties = {
                Texture = TEXTURE.Get("ball")
            }
        }
    }, pos)
end