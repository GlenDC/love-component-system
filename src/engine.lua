require "lcs.src.entity"
require "lcs.src.math"

require 'lcs.src.component_sprite'
require 'lcs.src.component_quad'
require 'lcs.src.component_circle'
require 'lcs.src.component_animated_sprite'
require 'lcs.src.component_physic'
require 'lcs.src.component_physic_world'
require 'lcs.src.component_camera'
require 'lcs.src.component_text'
require 'lcs.src.component_particle'
require 'lcs.src.component_sprite_batch'
require 'lcs.src.component_static_sprite'
require 'lcs.src.component_bounding'
require 'lcs.src.component_bounding_world'
require 'lcs.src.component_lifetime'

require 'lcs.src.state_machine'

require 'lcs.src.texture'
require 'lcs.src.animation'
require 'lcs.src.sprite_sheet'

ENGINE = {
    RenderWorlds = {},
    Cameras = {},
    ViewportDimensions = { 0, 0 },
    ViewportOffset = { 0, 0 },
    ScreenAspectRatio = 0.0,
    ScreenScaleRatio = 1.0
}

function ENGINE.CalculateScreenScaleValues( working_res )
     local screen_res = {
        love.graphics.getWidth(),
        love.graphics.getHeight()
        }

    local width = screen_res[ 1 ] / working_res[ 1 ]
    local height = screen_res[ 2 ] / working_res[ 2 ]

    if width > height then
        height = screen_res[ 2 ]
        ENGINE.ScreenAspectRatio = working_res[ 1 ] / working_res[ 2 ]
        width = height * ENGINE.ScreenAspectRatio

        ENGINE.ViewportOffset[ 1 ] = ( screen_res[ 1 ] - width ) / 2
    else
        width = screen_res[ 1 ]
        ENGINE.ScreenAspectRatio = working_res[ 2 ] / working_res[ 1 ]
        height = width * ENGINE.ScreenAspectRatio

        ENGINE.ViewportOffset[ 2 ] = ( screen_res[ 2 ] - height ) / 2
    end

    ENGINE.ViewportDimensions[ 1 ] = width
    ENGINE.ViewportDimensions[ 2 ] = height

    ENGINE.ScreenScaleRatio = ENGINE.ViewportDimensions[ 1 ] / working_res[ 1 ]
end

function ENGINE.Initialize(arg, working_res)
    if arg[#arg] == "-debug" then require("mobdebug").start() end
    ENGINE.CalculateScreenScaleValues( working_res )
end

function ENGINE.Update(dt)
    ENTITY.UpdateAll(dt)
end

function ENGINE.Render()
    ENGINE.RenderWorlds = {}

    ENTITY.PreRenderAll()

    love.graphics.setColor( { 255, 255, 0, 255 } ) -- :TODO: use user defined viewport Color

    love.graphics.rectangle(
        "fill",
        ENGINE.ViewportOffset[ 1 ],
        ENGINE.ViewportOffset[ 2 ],
        ENGINE.ViewportDimensions[ 1 ],
        ENGINE.ViewportDimensions[ 2 ]
        )

    for k,w in pairs(ENGINE.RenderWorlds) do
        if ENGINE.Cameras[k] then
            ENGINE.Cameras[k]:Apply()
        end

        local a = {}
        for n in pairs(w) do table.insert(a, n) end
        table.sort(a)

        for i,n in ipairs(a) do
            for _,item in ipairs(w[n]) do
                item:Render()
            end
        end
    end
end

function ENGINE.AddRenderable(item, layer, world)
    world = world or 1
    if not ENGINE.RenderWorlds[world] then
        ENGINE.RenderWorlds[world] = {}
    end

    if not ENGINE.RenderWorlds[world][layer] then
        ENGINE.RenderWorlds[world][layer] = {}
    end

    table.insert(ENGINE.RenderWorlds[world][layer], item)
end

function ENGINE.DebugDraw()
    love.graphics.setColor({0,0,0,128})
    love.graphics.rectangle("fill", 0, 20, 128, 20 )
    love.graphics.print("Entities: " .. #ENTITY.Items, 10, 20)
    love.graphics.setColor({255,255,255,255})

    love.graphics.print("Entities: " .. #ENTITY.Items, 11, 21)
    love.graphics.setColor({255,255,255,255})
end

function ENGINE.SetCamera(w, camera)
    ENGINE.Cameras[w] = camera
end