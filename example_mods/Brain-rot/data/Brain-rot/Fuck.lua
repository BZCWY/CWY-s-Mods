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
    if getProperty('healthBarBG') ~= nil then
        setProperty('healthBarBG.visible', false)
    end
    if getProperty('iconP1') ~= nil then
        setProperty('iconP1.visible', false)
    end
    if getProperty('iconP2') ~= nil then
        setProperty('iconP2.visible', false)
    end
    if getProperty('scoreTxt') ~= nil then
        setProperty('scoreTxt.visible', false)
    end
    if getProperty('missesTxt') ~= nil then
        setProperty('missesTxt.visible', false)
    end
    if getProperty('rating') ~= nil then
        setProperty('rating.visible', false)
    end
    if getProperty('ratingFC') ~= nil then
        setProperty('ratingFC.visible', false)
    end
    if getProperty('botplayTxt') ~= nil then
        setProperty('botplayTxt.visible', false)
    end
    if getProperty('timeBarBG') ~= nil then
        setProperty('timeBarBG.visible', false)
    end
    if getProperty('timeBar') ~= nil then
        setProperty('timeBar.visible', false)
    end
    if getProperty('timeTxt') ~= nil then
        setProperty('timeTxt.visible', false)
    end
end
function onStepHit()
    if curStep == 50 then
        for i = 0,3 do
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