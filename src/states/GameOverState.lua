GameOverState = Class{__includes=BaseState}

function GameOverState:enter(params)
    self.score = params.score
    self.highScores = params.highScores
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        local highScore = false
        local hscoreIndex = 11

        for i = 10, 1, -1 do
            local score = self.highScores[i].score or 0
            if self.score > score then
                hscoreIndex = i
                highScore = true
            end
        end
        if highScore then
            Gsounds['high-score']:play()
            GstateMachine:change('enter-high-score', {
                highScores = self.highScores,
                score = self.score,
                scoreIndex = hscoreIndex
            })
        else
            GstateMachine:change('start', {highScores = self.highScores})
        end
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function GameOverState:render()
    love.graphics.setFont(Gfonts['large'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')
    love.graphics.setFont(Gfonts['medium'])
    love.graphics.printf('Final Score: '..tostring(self.score), 0, VIRTUAL_HEIGHT/2, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to start again.', 0, (3*VIRTUAL_HEIGHT)/4, VIRTUAL_WIDTH, 'center')
end
