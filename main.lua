require('src.Dependencies')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    love.window.setTitle('Breakout')

    Gfonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
    }
    love.graphics.setFont(Gfonts['small'])

    Gtextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
    }

    Gframes = {
        ['paddles'] = GenerateQuadsPaddles(Gtextures['main']),
        ['balls'] = GenerateQuadsBalls(Gtextures['main']),
        ['bricks'] = GenerateQuadsBricks(Gtextures['main']),
        ['hearts'] = GenerateQuads(Gtextures['hearts'], 10, 9),
        ['arrows'] = GenerateQuads(Gtextures['arrows'], 24, 24)
    }

    Push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    Gsounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/bounce.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-1'] = love.audio.newSource('sounds/brick-1.wav', 'static'),
        ['brick-2'] = love.audio.newSource('sounds/brick-2.wav', 'static'),
        ['crash'] = love.audio.newSource('sounds/crash.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/highscore.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        --https://freesound.org/people/Seth_Makes_Sounds/sounds/657804/
        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    Gsounds['music']:setLooping(true)
    Gsounds['music']:play()

    GstateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end,
        ['serve'] = function() return ServeState() end,
        ['gameover'] = function() return GameOverState() end,
        ['victory'] = function() return VictoryState() end,
        ['highscore'] = function() return HighScoresState() end,
        ['enter-high-score'] = function() return EnterHighScoreState() end,
        ['paddle-select'] = function() return PaddleSelectState() end
    }
    GstateMachine:change('start', {highScores = LoadHighScores()})

    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    Push:resize(w, h)
end

function love.update(dt)
   GstateMachine:update(dt)
   love.keyboard.keysPressed = {}
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.draw()
    Push:apply('start')

    local backgroundWidth = Gtextures['background']:getWidth()
    local backgroundHeight = Gtextures['background']:getHeight()

    love.graphics.draw(
        Gtextures['background'],
        0, 0,
        0,
        VIRTUAL_WIDTH/(backgroundWidth-1), VIRTUAL_HEIGHT/(backgroundHeight-1)
    )

    GstateMachine:render()

    Push:apply('end')
end

function LoadHighScores()
    love.filesystem.setIdentity('breakout')

    if not love.filesystem.getInfo('breakout.lst') then
        local scores = ''
        for i = 10, 1, -1 do
            scores = scores .. '---\n'
            scores = scores .. tostring(0) .. '\n'
        end
        love.filesystem.write('breakout.lst', scores)
    end

    local name = true
    local counter = 1
    local scores = {}

    for i = 1, 10 do
        scores[i] = {name = nil, score=nil}
    end

    for line in love.filesystem.lines('breakout.lst') do
        if name then
            scores[counter].name = string.sub(line, 1, 3)
        else
            scores[counter].score = tonumber(line)
            counter = counter+1
        end
        name = not name
    end

    return scores
end

function RenderScore(score)
    love.graphics.setFont(Gfonts['small'])
    love.graphics.print('Score:', VIRTUAL_WIDTH-60, 5)
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH-50, 5, 40, 'right')
end

function RenderHealth(health)
    local healthX = VIRTUAL_WIDTH - 100
    for i = 1,health do
        love.graphics.draw(Gtextures['hearts'], Gframes['hearts'][1], healthX, 4)
        healthX = healthX+11
    end
    for i = 1, 3-health do
        love.graphics.draw(Gtextures['hearts'], Gframes['hearts'][2], healthX, 4)
        healthX = healthX+11
    end
end
