GameOverState = Class{__includes=BaseState}

function GameOverState:enter(params)
    self.score = params.score
end

function GameOverState:update(dt)
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        GstateMachine:change('start')
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
