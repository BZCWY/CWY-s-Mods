local ICON_X = 0
local ICON_Y = 530
local ICON_SCALE = 1
local BEAT_SCALE = 1.2
local HEALTH_THRESHOLD = 80

local FLIP_ICON = false
local ICON_FILE = 'Dynamic-state_icons/ICON-MIKU'

local MOVE_WITH_HEALTH = true
local MIN_X = 730
local MAX_X = 140
local MOVE_SMOOTHNESS = 1

local iconState = "normal"
local targetX = ICON_X

function onCreate()
    setProperty('iconP2.alpha', 0)
    makeAnimatedLuaSprite('dad-icon', ICON_FILE, ICON_X, ICON_Y)
    addAnimationByPrefix('dad-icon', 'normal', 'ICON-DANGER', 10, true)
    addAnimationByPrefix('dad-icon', 'losing', 'ICON-NORMAL', 10, true)
    setObjectCamera('dad-icon', 'hud')
    scaleObject('dad-icon', ICON_SCALE, ICON_SCALE)
    setProperty('dad-icon.antialiasing', true)
    if FLIP_ICON then
        setProperty('dad-icon.flipX', true)
    end
    objectPlayAnimation('dad-icon', 'normal', true)
    iconState = "normal"

    addLuaSprite('dad-icon', true)

    setProperty('dad-icon.y', (downscroll and -32 or 530))

    local baseOrder = getObjectOrder('iconP1')
    if baseOrder then
        setObjectOrder('dad-icon', baseOrder + 11)  
    end

    targetX = calculateTargetX()
end

function calculateTargetX()
    if not MOVE_WITH_HEALTH then
        return ICON_X
    end
    local healthPercent = getProperty('healthBar.percent')
    healthPercent = math.max(0, math.min(100, healthPercent))
    return MIN_X + (MAX_X - MIN_X) * (healthPercent / 100)
end

function smoothMove()
    if not MOVE_WITH_HEALTH then return end
    local currentX = getProperty('dad-icon.x')
    local newX = currentX + (targetX - currentX) * MOVE_SMOOTHNESS
    if math.abs(targetX - currentX) < 0.5 then
        setProperty('dad-icon.x', targetX)
    else
        setProperty('dad-icon.x', newX)
    end
end

function onUpdate(elapsed)
    local healthPercent = getProperty('healthBar.percent')

    if MOVE_WITH_HEALTH then
        targetX = calculateTargetX()
        smoothMove()
    end

    if healthPercent >= HEALTH_THRESHOLD and iconState == "losing" then
        objectPlayAnimation('dad-icon', 'normal', true)
        iconState = "normal"
    elseif healthPercent < HEALTH_THRESHOLD and iconState == "normal" then
        objectPlayAnimation('dad-icon', 'losing', true)
        iconState = "losing"
    end
end

function onBeatHit()
    scaleObject('dad-icon', BEAT_SCALE, BEAT_SCALE)
    doTweenX('dadScaleX', 'dad-icon.scale', ICON_SCALE, 0.2, 'circOut')
    doTweenY('dadScaleY', 'dad-icon.scale', ICON_SCALE, 0.2, 'circOut')
end