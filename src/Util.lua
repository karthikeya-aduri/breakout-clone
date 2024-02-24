function GenerateQuads(atlas, tileWidth, tileHeight)
    local sheetWidth = atlas:getWidth()/tileWidth
    local sheetHeight = atlas:getHeight()/tileHeight

    local sheetCounter = 1
    local spriteSheet = {}

    for y = 0, sheetHeight-1 do
        for x = 0, sheetWidth-1 do
            spriteSheet[sheetCounter] =
            love.graphics.newQuad(
                x*tileWidth,
                y*tileHeight,
                tileWidth,
                tileHeight,
                atlas:getDimensions()
            )
            sheetCounter = sheetCounter+1
        end
    end

    return spriteSheet
end

function table.slice(tabl, start, finish, skip)
    local sliced = {}
    for i = start or 1, finish or (#tabl), skip or 1 do
        sliced[#sliced+1] = tabl[i]
    end
    return sliced
end

function GenerateQuadsPaddles(atlas)
    local x = 0
    local y = 64

    local counter = 1
    local quads = {}

    for i = 0, 3 do
        quads[counter] = love.graphics.newQuad(x, y, 32, 16, atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x+32, y, 64, 16, atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x+96, y, 96, 16, atlas:getDimensions())
        counter = counter + 1
        quads[counter] = love.graphics.newQuad(x, y+16, 32, 16, atlas:getDimensions())
        counter = counter + 1
        x = 0
        y = y + 32
    end

    return quads
end
