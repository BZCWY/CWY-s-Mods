function onCreate()
    makeLuaSprite('B', 'BG3', -750, -1000)
    scaleObject('B', 2, 2)
    setScrollFactor('B', 1, 1)
    addLuaSprite('B', false)

    makeLuaSprite('A', 'SB', -950, -950)
    scaleObject('A', 0.5, 0.5)
    setScrollFactor('A', 1, 1)
    addLuaSprite('A', false)

    makeLuaSprite('goose', 'Unknown-Mother-Goose', 450, 100)
    scaleObject('goose', 0.5, 0.5)
    setScrollFactor('goose', 1, 1)
    addLuaSprite('goose', false)
end

function onUpdate(elapsed)
    local newY = 100 + 30 * math.sin(getSongPosition() / 1000)
    setProperty('goose.y', newY)
end
