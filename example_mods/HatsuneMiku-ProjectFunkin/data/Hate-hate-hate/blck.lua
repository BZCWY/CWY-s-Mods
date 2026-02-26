local blackHudOverlay = nil
local hudBlackActive = false

function onCreate()
    local hudWidth = getProperty('camHUD.width')
    local hudHeight = getProperty('camHUD.height')
    
    blackHudOverlay = makeLuaSprite('blackHudOverlay', '', 0, 0)
    makeGraphic('blackHudOverlay', hudWidth, hudHeight, '000000')
    setProperty('blackHudOverlay.alpha', 0)
    setProperty('blackHudOverlay.visible', false)
    setProperty('blackHudOverlay.antialiasing', false) 
    addLuaSprite('blackHudOverlay', true)
    setObjectOrder('blackHudOverlay', 99999)  
    setObjectCamera('blackHudOverlay', 'hud')
end

function onStepHit()
    if curStep == 1343 then
        showBlackHudOverlay()
    end
end

function showBlackHudOverlay()
    if hudBlackActive then return end
    setProperty('blackHudOverlay.visible', true)
    setProperty('blackHudOverlay.alpha', 1)
    updateBlackHudOverlay()    
    hudBlackActive = true
end

function updateBlackHudOverlay()
    if blackHudOverlay == nil then return end
    
    local hudWidth = getProperty('camHUD.width')
    local hudHeight = getProperty('camHUD.height')

    makeGraphic('blackHudOverlay', hudWidth, hudHeight, '000000')
    setProperty('blackHudOverlay.x', 0)
    setProperty('blackHudOverlay.y', 0)
    setObjectCamera('blackHudOverlay', 'hud')
    setObjectOrder('blackHudOverlay', 99999)
end

function fadeInBlackHudOverlay(duration)
    if hudBlackActive then return end
    
    setProperty('blackHudOverlay.visible', true)
    setProperty('blackHudOverlay.alpha', 0)
    
    updateBlackHudOverlay()
    
    doTweenAlpha('fadeInHudBlack', 'blackHudOverlay', 1, duration or 0.5, 'linear')
    
    hudBlackActive = true
end

function fadeOutBlackHudOverlay(duration)
    if not hudBlackActive then return end
    
    doTweenAlpha('fadeOutHudBlack', 'blackHudOverlay', 0, duration or 0.5, 'linear')
    
    runTimer('hideBlackHudAfterFade', duration or 0.5)
end

function hideBlackHudOverlay()
    setProperty('blackHudOverlay.visible', false)
    setProperty('blackHudOverlay.alpha', 0)
    hudBlackActive = false
end

function removeBlackHudOverlay()
    if getProperty('blackHudOverlay') then
        removeLuaSprite('blackHudOverlay', true)
        blackHudOverlay = nil
    end
    hudBlackActive = false
end

function onTimerCompleted(tag)
    if tag == 'hideBlackHudAfterFade' then
        hideBlackHudOverlay()
    end
end

function onUpdate()
    
    if getProperty('blackHudOverlay.visible') then
        setObjectOrder('blackHudOverlay', 99999)
        setObjectCamera('blackHudOverlay', 'hud')
    end
    
    if hudBlackActive then
        if not getProperty('blackHudOverlay.visible') then
            setProperty('blackHudOverlay.visible', true)
        end
   
        if getProperty('blackHudOverlay.alpha') < 1 then
            setProperty('blackHudOverlay.alpha', 1)
        end
    end
end

function onDestroy()
    if getProperty('blackHudOverlay') then
        removeLuaSprite('blackHudOverlay', true)
    end
    blackHudOverlay = nil
    hudBlackActive = false
end