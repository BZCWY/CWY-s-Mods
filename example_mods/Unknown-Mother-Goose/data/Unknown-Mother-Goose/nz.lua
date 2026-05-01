function onCreate()
    makeLuaSprite('blackScreen', nil, 0, 0)
    makeGraphic('blackScreen', screenWidth, screenHeight, '000000')
    setObjectCamera('blackScreen', 'hud')   
    setProperty('blackScreen.alpha', 0)     
    addLuaSprite('blackScreen', true)        
end

function onStepHit()
    if curStep == 3985 then
        setProperty('blackScreen.alpha', 1)
    end
end