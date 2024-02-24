Brick = Class{}

function Brick:init(x, y)
    self.tier = 0
    self.color = 1

    self.x = x
    self.y = y

    self.width = 32
    self.height = 16

    self.inPlay = true
end

function Brick:hit()
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

function Brick:render()
    if self.inPlay then
        love.graphics.draw(Gtextures['main'], Gframes['bricks'][1 + self.tier + (self.color-1)*4], self.x, self.y)
    end
end
