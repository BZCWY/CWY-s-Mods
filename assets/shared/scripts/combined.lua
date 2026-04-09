settings = {
    FlipBar = false,    
    VerticalBar = false
}
local health = 1
local percent = 1
local HPSmooth = 1
local miss = false       
local pressedTime = {nil, nil, nil, nil} 

function math.lerp(a, b, ratio)
    return a + ratio * (b - a)
end

function math.boundTo(value, min, max)
    local newValue = value
    if newValue < min then newValue = min end
    if newValue > max then newValue = max end
    return newValue
end
function onCreate()
    setProperty('healthBar.numDivisions', 10000)
end
function onUpdatePost(elapsed)
    if getProperty('health') < 2 then
        health = math.lerp(health, getProperty('health'), math.boundTo(elapsed * 20, 0, 1))
    else
        health = 2
    end
    HPSmooth = math.lerp(HPSmooth, getProperty('health') * 50, elapsed * 20)
    setProperty('healthBar.percent', HPSmooth)
    if settings.FlipBar then
        percent = health / 2
        setProperty('iconP1.x', -105 + getProperty('healthBar.x') + (getProperty('healthBar.width') * percent) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
        setProperty('iconP2.x', 105 + getProperty('healthBar.x') + (getProperty('healthBar.width') * percent) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
        setProperty('iconP1.flipX', true)
        setProperty('iconP2.flipX', true)
        setProperty('healthBar.flipX', true)
        setProperty('healthBar.angle', 0)
    else
        percent = 1 - (health / 2)
        setProperty('iconP1.x', getProperty('healthBar.x') + (getProperty('healthBar.width') * percent) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
        setProperty('iconP2.x', getProperty('healthBar.x') + (getProperty('healthBar.width') * percent) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
        setProperty('iconP1.flipX', false)
        setProperty('iconP2.flipX', false)
        setProperty('healthBar.flipX', false)
        setProperty('healthBar.angle', 0)
    end
    if settings.VerticalBar then
        setProperty('healthBar.angle', 90)
        setProperty('healthBar.x', -220)
        setProperty('healthBar.y', 360)

        setProperty('iconP1.flipX', false)
        setProperty('iconP2.flipX', false)

        setProperty('iconP2.x', getProperty('healthBar.x') + 220)
        setProperty('iconP1.x', getProperty('healthBar.x') + 220)

        if settings.FlipBar then
            setProperty('healthBar.flipX', true)
            setProperty('iconP2.y', 395 + getProperty('healthBar.x') + (getProperty('healthBar.width') * percent) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
            setProperty('iconP1.y', 205 + getProperty('healthBar.x') + (getProperty('healthBar.width') * percent) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
        else
            setProperty('healthBar.flipX', false)
            setProperty('iconP2.y', 305 + getProperty('healthBar.x') + (getProperty('healthBar.width') * percent) - (150 * getProperty('iconP2.scale.x')) / 2 - 26 * 2)
            setProperty('iconP1.y', 295 + getProperty('healthBar.x') + (getProperty('healthBar.width') * percent) + (150 * getProperty('iconP1.scale.x') - 150) / 2 - 26)
        end
    end
    if combo == 0 and not miss then
        setTextString('scoreTxt', '分数: '..score..' | 失误: '..misses..' | 评分: '..ratingName)
    else
        setTextString('scoreTxt', '分数: '..score..' | 失误: '..misses..' | 评分: '..ratingName..' ('..math.floor(rating * 100 * 100) / 100 ..'%) - '..ratingFC)
    end
    setTextString('botplayTxt', "自动游玩")
    if getPropertyFromClass('states.PlayState', 'isPixelStage') == false then
        setTextFont('botplayTxt', 'riffic.ttf')
    end
    if getPropertyFromClass('states.PlayState', 'stageUI') == 'pixel' then
        setTextFont('botplayTxt', 'vcr.ttf')
    end
    local now = os.clock()
    local keys = {"left", "down", "up", "right"}
    for i = 0, 3 do
        if keyPressed(keys[i+1]) then
            if pressedTime[i+1] == nil then
                pressedTime[i+1] = now
            end
        else
            pressedTime[i+1] = nil
        end
        if pressedTime[i+1] and (now - pressedTime[i+1]) > 1 then
            if getProperty('boyfriend') then
                playAnim('boyfriend', 'idle', true)
            end
            pressedTime[i+1] = nil
        end
    end
end
function opponentNoteHit(id, direction, noteType, isSustainNote)
    if not isSustainNote then
        local curHealth = getProperty('health')
        if curHealth > 0.1 then
            setProperty('health', curHealth - 0.020)
        end
    end
end
function noteMiss()
    miss = true
end
function goodNoteHit(id, direction, noteType, isSustainNote)
    miss = false
    if direction >= 0 and direction <= 3 then
        pressedTime[direction+1] = os.clock() 
    end
end