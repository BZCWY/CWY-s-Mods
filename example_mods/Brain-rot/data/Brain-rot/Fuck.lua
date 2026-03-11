function onCreatePost()
    for i = 0,3 do
        setPropertyFromGroup('playerStrums', i, 'visible', false)
        setPropertyFromGroup('playerStrums', i, 'alpha', 0)
    end
    for i = 0,3 do
        setPropertyFromGroup('opponentStrums', i, 'visible', false)
        setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
    end
    setProperty('uiGroup.visible', false)
    if getProperty('healthBar') ~= nil then
        setProperty('healthBar.visible', false)
    end
end
function onStepHit()
    if curStep == 50 then
        for i = 0,3 do
            setProperty('uiGroup.visible', true)
            setProperty('timeTxt.visible', false)
            setProperty('timeBar.visible', false)
            setPropertyFromGroup('playerStrums', i, 'alpha', 0)
            setPropertyFromGroup('playerStrums', i, 'visible', true)
            setPropertyFromGroup('opponentStrums', i, 'alpha', 0)
            setPropertyFromGroup('opponentStrums', i, 'visible', true)
            
        end
        for i = 0, 3 do
            doTweenAlpha('playerFadeIn'..i, 'playerStrums.members['..i..']', 1, 1, 'sineInOut')
        end
        
        for i = 0, 3 do
            doTweenAlpha('opponentFadeIn'..i, 'opponentStrums.members['..i..']', 1, 1, 'sineInOut')
        end
    end
end