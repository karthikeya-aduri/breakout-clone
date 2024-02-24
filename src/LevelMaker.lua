LevelMaker = Class{}

function LevelMaker:createMap(level)
    local bricks = {}
    local numRows = math.random(1, 5)
    local numColumns = math.random(7, 13)

    for y = 1, numRows do
        for x = 1, numColumns do
            local b = Brick((x-1)*32+8+(13-numColumns)*16, y*16)
            table.insert(bricks,b)
        end
    end
    return bricks
end
