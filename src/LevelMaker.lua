None = 1
SinglePyramid = 2
MultiPyramid = 3

Solid = 1
Alternate = 2
Skip = 3

LevelMaker = Class{}

function LevelMaker:createMap(level)
    local bricks = {}
    local numRows = level%5==0 and 5 or level%5
    local numColumns = level>6 and 13 or (level+6)
    numColumns = numColumns%2==0 and (numColumns+1) or numColumns

    local highestTier = math.min(3, math.floor(level/5))
    local highestColor = math.min(5, level%5 + 3)

    for y = 1, numRows do
        local skipPattern = math.random(1,2)==1 and true or false
        local alternatePattern = math.random(1,2)==1 and true or false

        local alternateColor1 = math.random(1, highestColor)
        local alternateColor2 = math.random(1, highestColor)
        local alternateTier1 = math.random(0, highestTier)
        local alternateTier2 = math.random(0, highestTier)

        local skipFlag = math.random(2)==1 and true and false
        local alternateFlag = math.random(2) and true and false

        local solidColor = math.random(1, highestColor)
        local solidTier = math.random(0, highestTier)

        for x = 1, numColumns do
            if skipPattern and skipFlag then
                skipFlag = not skipFlag
                goto continue
            else
                skipFlag = not skipFlag
            end
            local b = Brick((x-1)*32+8+(13-numColumns)*16, y*16)

            if alternatePattern and alternateFlag then
                b.color = alternateColor1
                b.tier = alternateTier1
                alternateFlag = not alternateFlag
            else
                b.color = alternateColor2
                b.tier = alternateTier2
                alternateFlag = not alternateFlag
            end

            if not alternatePattern then
                b.color = solidColor
                b.tier = solidTier
            end
            table.insert(bricks,b)
            ::continue::
        end
    end

    if #bricks==0 then
        return self.createMap(level)
    else
        return bricks
    end
end
