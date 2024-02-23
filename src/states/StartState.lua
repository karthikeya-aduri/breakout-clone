StartState = Class{__includes = BaseState}

local highlighted = 0

function StartState:update(dt)
    if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
        highlighted = (highlighted+1)%2
        Gsounds['select']:play()
    end

    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function StartState:render()
    love.graphics.setFont(Gfonts['large'])
    love.graphics.printf('BREAKOUT', 0, VIRTUAL_HEIGHT/3, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(Gfonts['medium'])
    if highlighted==0 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf('START', 0, VIRTUAL_HEIGHT/2+70, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)

    if highlighted==1 then
        love.graphics.setColor(103/255, 1, 1, 1)
    end
    love.graphics.printf('HIGH SCORES', 0, VIRTUAL_HEIGHT/2+90, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
end
