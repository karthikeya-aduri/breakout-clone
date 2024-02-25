ServeState = Class{__includes=BaseState}

function ServeState:enter(params)
    self.paddle = params.paddle
    self.bricks = params.bricks
    self.health = params.health
    self.score = params.score
    self.level = params.level
    self.highScores = params.highScores

    self.ball = Ball(1)
    self.ball.skin = (self.level%7==0) and 7 or (self.level%7)
end

function ServeState:update(dt)
    self.paddle:update(dt)
    self.ball.x = self.paddle.x + (self.paddle.width/2)-4
    self.ball.y = self.paddle.y - 8

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GstateMachine:change('play',{
            paddle = self.paddle,
            ball = self.ball,
            health = self.health,
            score = self.score,
            bricks = self.bricks,
            level = self.level,
            highScores = self.highScores
        })
    elseif love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function ServeState:render()
    for k, brick in pairs(self.bricks) do
        brick:render()
    end
    self.paddle:render()
    self.ball:render()

    RenderScore(self.score)
    RenderHealth(self.health)

    love.graphics.setFont(Gfonts['medium'])
    love.graphics.printf('Press enter to serve!', 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
end
