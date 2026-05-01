local y0_p1, y1_p1, y2_p1, y3_p1

local swingAmps = {12, 4, 8, 16}
local swingFactor = 28
local errorIntensity = 1

local startSwing = false
local useErrorTexture = false

function onCreate()
    precacheImage('NOTE_assets')
    precacheImage('errorNOTE_assets')
end

function onCreatePost()
    for i = 0, getProperty('opponentStrums.length') - 1 do
        setPropertyFromGroup('opponentStrums', i, 'texture', 'NOTE_assets')
    end
    y0_p1 = getPropertyFromGroup('opponentStrums', 0, 'y')
    y1_p1 = getPropertyFromGroup('opponentStrums', 1, 'y')
    y2_p1 = getPropertyFromGroup('opponentStrums', 2, 'y')
    y3_p1 = getPropertyFromGroup('opponentStrums', 3, 'y')
end

function onStepHit()
    if curStep == 296 then
        useErrorTexture = true
        for i = 0, getProperty('opponentStrums.length') - 1 do
            setPropertyFromGroup('opponentStrums', i, 'texture', 'errorNOTE_assets')
        end
        for i = 0, getProperty('notes.length') - 1 do
            if not getPropertyFromGroup('notes', i, 'mustPress') then
                setPropertyFromGroup('notes', i, 'texture', 'errorNOTE_assets')
            end
        end
        for i = 0, getProperty('unspawnNotes.length') - 1 do
            if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                setPropertyFromGroup('unspawnNotes', i, 'texture', 'errorNOTE_assets')
            end
        end
        startSwing = true
    end

    if curStep == 3185 then
        startSwing = false
        useErrorTexture = false

        for i = 0, 3 do
            cancelTween('swingY' .. i)
        end

        setPropertyFromGroup('opponentStrums', 0, 'y', y0_p1)
        setPropertyFromGroup('opponentStrums', 1, 'y', y1_p1)
        setPropertyFromGroup('opponentStrums', 2, 'y', y2_p1)
        setPropertyFromGroup('opponentStrums', 3, 'y', y3_p1)

        for i = 0, getProperty('opponentStrums.length') - 1 do
            setPropertyFromGroup('opponentStrums', i, 'texture', 'NOTE_assets')
        end

        for i = 0, getProperty('notes.length') - 1 do
            if not getPropertyFromGroup('notes', i, 'mustPress') then
                setPropertyFromGroup('notes', i, 'texture', 'NOTE_assets')
            end
        end

        for i = 0, getProperty('unspawnNotes.length') - 1 do
            if not getPropertyFromGroup('unspawnNotes', i, 'mustPress') then
                setPropertyFromGroup('unspawnNotes', i, 'texture', 'NOTE_assets')
            end
        end
    end
end

function onUpdate(elapsed)
    if useErrorTexture and getProperty('notes.length') > 0 then
        for i = 0, getProperty('notes.length') - 1 do
            if not getPropertyFromGroup('notes', i, 'mustPress') then
                local curTex = getPropertyFromGroup('notes', i, 'texture')
                if curTex ~= 'errorNOTE_assets' then
                    setPropertyFromGroup('notes', i, 'texture', 'errorNOTE_assets')
                end
            end
        end
    end

    if startSwing then
        local songPos = getSongPosition()
        local currentBeat = (songPos / 1000) * (bpm / 60)

        local randOffset = {
            math.sin(currentBeat * 13.7) * errorIntensity * 3,
            math.cos(currentBeat * 11.3) * errorIntensity * 3,
            math.sin(currentBeat * 17.2 + 1.2) * errorIntensity * 3,
            math.cos(currentBeat * 19.8 + 2.4) * errorIntensity * 3
        }

        local dynamicAmps = {}
        for i = 1, 4 do
            dynamicAmps[i] = swingAmps[i]
            if math.floor(currentBeat) % 4 == 0 then
                dynamicAmps[i] = swingAmps[i] * (1 + math.sin(currentBeat * 2 + i) * 0.5)
            end
        end

        noteTweenY('swingY0', 0, y0_p1 + (dynamicAmps[1] + randOffset[1]) * math.cos((currentBeat + 0) * math.pi * 16 / swingFactor), 0.0001)
        noteTweenY('swingY1', 1, y1_p1 + (dynamicAmps[2] + randOffset[2]) * math.cos((currentBeat + 1) * math.pi * 16 / swingFactor), 0.0001)
        noteTweenY('swingY2', 2, y2_p1 + (dynamicAmps[3] + randOffset[3]) * math.cos((currentBeat + 2) * math.pi * 16 / swingFactor), 0.0001)
        noteTweenY('swingY3', 3, y3_p1 + (dynamicAmps[4] + randOffset[4]) * math.cos((currentBeat + 3) * math.pi * 16 / swingFactor), 0.0001)
    end
end