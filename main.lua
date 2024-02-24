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
        ['balls'] = GenerateQuadsBalls(Gtextures['main'])
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

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
    }

    GstateMachine = StateMachine {
        ['start'] = function() return StartState() end,
        ['play'] = function() return PlayState() end
    }
    GstateMachine:change('start')

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
