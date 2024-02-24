Ball = Class{}

function Ball:init()
    self.width = 8
    self.height = 8

    self.dx = 0
    self.dy = 0

    self.skin = 1
end

function Ball:collides(target)
    if self.x > target.x+target.width or self.x+self.width < target.x then
        return false
    end

    if self.y > target.y+target.height or self.y+self.height < target.y then
        return false
    end

    return true
end

function Ball:reset()
    self.x = VIRTUAL_WIDTH/2 - 4
    self.y = VIRTUAL_HEIGHT - 42
    self.dx = 0
    self.dy = 0
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.x<=0 then
        self.x = 0
        self.dx = -self.dx
        Gsounds['wall-hit']:play()
    end

    if self.x>=VIRTUAL_WIDTH-8 then
        self.x = VIRTUAL_WIDTH-8
        self.dx = -self.dx
        Gsounds['wall-hit']:play()
    end

    if self.y<=0 then
        self.y = 0
        self.dy = -self.dy
        Gsounds['wall-hit']:play()
    end
end

function Ball:render()
    love.graphics.draw(Gtextures['main'], Gframes['balls'][self.skin], self.x, self.y)
end
