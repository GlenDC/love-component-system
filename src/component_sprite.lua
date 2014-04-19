require 'lcs.src.class'

COMPONENT_SPRITE = class( function( o, parameters, entity )
    o.Texture = parameters.Texture
    o.Quad = parameters.Quad
    o.Extent = parameters.Extent
    o.Offset = parameters.Offset
    o.Scale = parameters.Scale
    o.Layer = parameters.Layer or 1
    o.Entity = entity
    o.Color = parameters.Color or { 255, 255, 255, 255 }

    local x,y,w,h

    if o.Quad then
        x,y,w,h = o.Quad:getViewport()
    else
        w = o.Texture:getWidth()
        h = o.Texture:getHeight()
    end

    if o.Extent == nil then
        o.Extent = { w, h }
    end

    if o.Offset == nil then
        o.Offset = { 0.5, 0.5 }
    end

    if o.Scale == nil then
        o.Scale = { 1.0, 1.0 }
    end

    o.World = parameters.World or 1

    o.Entity.Extent = o.Extent
end)

-- METHODS

function COMPONENT_SPRITE:Update()
end

function COMPONENT_SPRITE:PreRender()
    ENGINE.AddRenderable( self, self.Layer, self.World )
end

function COMPONENT_SPRITE:Render()
    local position = self.Entity.Position
    love.graphics.setColor( self.Color )

    local position_x =
        ENGINE.ViewportOffset[ 1 ] +
            ( position[ 1 ] * ENGINE.ScreenScaleRatio )
    local position_y =
        ENGINE.ViewportOffset[ 2 ] +
            ( position[ 2 ] * ENGINE.ScreenScaleRatio )

    local scale_x = self.Scale[ 1 ] * ENGINE.ScreenScaleRatio
    local scale_y = self.Scale[ 2 ] * ENGINE.ScreenScaleRatio

    local offset_x = self.Offset[ 1 ]
    local offset_y = self.Offset[ 2 ]

    -- :TODO: Why is the offset wrong with 1 pixel?

    if self.Quad then
        love.graphics.draw(
            self.Texture,
            self.Quad,
            position_x,
            position_y,
            self.Entity.Orientation,
            scale_x,
            scale_y,
            offset_x,
            offset_y
            )
    else
        love.graphics.draw(
            self.Texture,
            position_x,
            position_y,
            self.Entity.Orientation,
            scale_x,
            scale_y,
            offset_x,
            offset_y
            )
    end
end

function COMPONENT_SPRITE:SetColor( color )
    self.Color = color
end

function COMPONENT_SPRITE:SetSpriteTexture( texture )
    self.Texture = texture
end