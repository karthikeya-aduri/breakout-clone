PlayState = Class{__includes=BaseState}

function PlayState:enter(params)
    self.paddle = params.paddle
    self.ball = params.ball
    self.health = params.health
    self.score = params.score
    self.bricks = params.bricks

    self.ball.dx = math.random(-200, 200)
    self.ball.dy = math.random(-60, -30)
    self.paused = false
end

function PlayState:update(dt)
    if self.paused then
        if love.keyboard.wasPressed('space') then
            self.paused = false
            Gsounds['pause']:play()
        else
            return
        end
    elseif love.keyboard.wasPressed('space') then
        self.paused = true
        Gsounds['pause']:play()
    end

    self.paddle:update(dt)
    self.ball:update(dt)

    if self.ball:collides(self.paddle) then
        self.ball.y = self.paddle.y-8
        self.ball.dy = -self.ball.dy

        if self.ball.x < self.paddle.x + (self.paddle.width/2) and self.paddle.dx<0 then
            self.ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width/2 - self.ball.x))
        elseif self.ball.x > self.paddle.x + (self.paddle.width/2) and self.paddle.dx>0 then
            self.ball.dx = 50 + math.abs(8 * (self.paddle.x + self.paddle.width/2 - self.ball.x))
        end

        Gsounds['paddle-hit']:play()
    end

    for k, brick in pairs(self.bricks) do
        if brick.inPlay and self.ball:collides(brick) then
            self.score = self.score + (brick.tier*200 + brick.color*25)
            brick:hit()
            if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
                self.ball.x = brick.x - 8
                self.ball.dx = -self.ball.dx
            elseif self.ball.x + 6 > brick.x+brick.width and self.ball.dx < 0 then
                self.ball.x = brick.x + 32
                self.ball.dx = -self.ball.dx
            elseif self.ball.y < brick.y then
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y - 8
            else
                self.ball.dy = -self.ball.dy
                self.ball.y = brick.y + 16
            end
            self.ball.dy = self.ball.dy * 1.03
            break
        end
    end

    if self.ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        Gsounds['crash']:play()
        if self.health==0 then
            GstateMachine:change('gameover', {score = self.score})
        else
            GstateMachine:change('serve',{
                paddle = self.paddle,
                bricks = self.bricks,
                health = self.health,
                score = self.score
            })
        end
    end

    for k, brick in pairs(self.bricks) do
        brick:update(dt)
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PlayState:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end

    for k, brick in pairs(self.bricks) do
        brick:renderParticles()
    end

    self.paddle:render()
    self.ball:render()

    RenderScore(self.score)
    RenderHealth(self.health)

    if self.paused then
        love.graphics.setFont(Gfonts['large'])
        love.graphics.printf('PAUSED', 0, VIRTUAL_HEIGHT/2-16, VIRTUAL_WIDTH, 'center')
    end
end
