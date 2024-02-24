Brick = Class{}

PaletteColors = {
    [1] = {['r']=89, ['g']=209, ['b']=225},
    [2] = {['r']=106, ['g']=190, ['b']=47},
    [3] = {['r']=217, ['g']=87, ['b']=99},
    [4] = {['r']=215, ['g']=123, ['b']=186},
    [5] = {['r']=251, ['g']=242, ['b']=54}
}

function Brick:init(x, y)
    self.tier = 0
    self.color = 1

    self.x = x
    self.y = y

    self.width = 32
    self.height = 16

    self.inPlay = true

    self.psystem = love.graphics.newParticleSystem(Gtextures['particle'], 64)
    self.psystem:setParticleLifetime(0.5, 0.75)
    self.psystem:setLinearAcceleration(-15, 0, 15, 80)
    self.psystem:setEmissionArea('normal', 9, 9)
end

function Brick:hit()
    self.psystem:setColors(
        PaletteColors[self.color].r/255,
        PaletteColors[self.color].g/255,
        PaletteColors[self.color].b/255,
        (55*(self.tier+1))/255,
        PaletteColors[self.color].r/255,
        PaletteColors[self.color].g/255,
        PaletteColors[self.color].b/255,
        0
    )
    self.psystem:emit(64)

    Gsounds['brick-2']:stop()
    Gsounds['brick-2']:play()
    if self.tier>0 then
        if self.color==1 then
            self.tier = self.tier - 1
            self.color = 5
        else
            self.color = self.color - 1
        end
    else
        if self.color==1 then
            self.inPlay = false
        else
            self.color = self.color - 1
        end
    end

    if not self.inPlay then
        Gsounds['brick-1']:stop()
        Gsounds['brick-1']:play()
    end
end

function Brick:update(dt)
    self.psystem:update(dt)
end

function Brick:render()
    if self.inPlay then
        love.graphics.draw(Gtextures['main'], Gframes['bricks'][1 + self.tier + (self.color-1)*4], self.x, self.y)
    end
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x+16, self.y+8)
end
