PaddleSelectState = Class{__includes=BaseState}

function PaddleSelectState:enter(params)
    self.highScores = params.highScores
end

function PaddleSelectState:init()
    self.currentPaddle = 1
end

function PaddleSelectState:update(dt)
    if love.keyboard.wasPressed('left') then
        if self.currentPaddle == 1 then
            Gsounds['no-select']:play()
        else
            Gsounds['select']:play()
            self.currentPaddle = self.currentPaddle - 1
        end
    elseif love.keyboard.wasPressed('right') then
        if self.currentPaddle == 4 then
            Gsounds['no-select']:play()
        else
            Gsounds['select']:play()
            self.currentPaddle = self.currentPaddle + 1
        end
    end

    if love.keyboard.wasPressed('return') or love.keyboard.wasPressed('enter') then
        Gsounds['confirm']:play()
        GstateMachine:change('serve', {
            paddle = Paddle(self.currentPaddle),
            bricks = LevelMaker:createMap(1),
            health = 3,
            score = 0,
            highScores = self.highScores,
            level = 1
        })
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function PaddleSelectState:render()
    love.graphics.setFont(Gfonts['medium'])
    love.graphics.printf('Select your paddle by pressing left and right.', 0, VIRTUAL_HEIGHT/4, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(Gfonts['small'])
    love.graphics.printf('Press enter to continue.', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

    if self.currentPaddle==1 then
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    love.graphics.draw(Gtextures['arrows'], Gframes['arrows'][1], VIRTUAL_WIDTH/4, (2*VIRTUAL_HEIGHT)/3)
    love.graphics.setColor(1, 1, 1, 1)


    if self.currentPaddle==4 then
        love.graphics.setColor(40/255, 40/255, 40/255, 128/255)
    end
    love.graphics.draw(Gtextures['arrows'], Gframes['arrows'][2], (3*VIRTUAL_WIDTH)/4-24, (2*VIRTUAL_HEIGHT)/3)
    love.graphics.setColor(1, 1, 1, 1)

    love.graphics.draw(Gtextures['main'], Gframes['paddles'][2 + 4*(self.currentPaddle-1)], VIRTUAL_WIDTH/2-32, (2*VIRTUAL_HEIGHT)/3)
end
