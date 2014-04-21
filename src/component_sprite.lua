require 'lcs.src.class'

COMPONENT_SPRITE = class( function( o, parameters, entity )
    o.Texture = parameters.Texture
    o.Quad = parameters.Quad
    o.Extent = parameters.Extent
    o.Offset = parameters.Offset
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
        o.Scale = { 1.0, 1.0 }
    else
        o.Scale = { w / o.Extent[ 1 ], h / o.Extent[ 2 ] }
    end

    if o.Offset == nil then
        o.Offset = { 0.5, 0.5 }
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

    if self.Quad then
        love.graphics.draw(
            self.Texture,
            self.Quad,
            position[ 1 ],
            position[ 2 ],
            self.Entity.Orientation,
            self.Scale[ 1 ],
            self.Scale[ 2 ],
            self.Offset[ 1 ],
            self.Offset[ 2 ]
            )
    else
        love.graphics.draw(
            self.Texture,
            position[ 1 ],
            position[ 2 ],
            self.Entity.Orientation,
            self.Scale[ 1 ],
            self.Scale[ 2 ],
            self.Offset[ 1 ],
            self.Offset[ 2 ]
            )
    end
end

function COMPONENT_SPRITE:SetColor( color )
    self.Color = color
end

function COMPONENT_SPRITE:SetSpriteTexture( texture )
    self.Texture = texture
end