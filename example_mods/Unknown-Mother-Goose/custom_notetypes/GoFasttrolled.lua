--Creator
--Idea by MoonScarf
--Created by Kevin Kuntz
--Modified by ThisIsVerdi
local offsetYy = {-4160,4160}
function onCreatePost()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		Os = getPropertyFromGroup('unspawnNotes', i, 'isSustainNote')
		mustPress = getPropertyFromGroup('unspawnNotes', i, 'mustPress')
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'GoFasttrolled' then
			if not Os then
				oFY = getPropertyFromGroup('unspawnNotes', i, 'offsetY')
			else
				OsFY = getPropertyFromGroup('unspawnNotes', i, 'offsetY')
			end
			if mustPress then
				setPropertyFromGroup('unspawnNotes', i, 'offsetY', getPropertyFromGroup('unspawnNotes', i, 'offsetY') + offsetYy[(downscroll and 1 or 2)])
			else
				setPropertyFromGroup('unspawnNotes', i, 'offsetY', getPropertyFromGroup('unspawnNotes', i, 'offsetY') + offsetYy[(downscroll and 1 or 2)])
			end
        end
    end
end

function onUpdatePost(el)
    songPos = getSongPosition()
	local currentBeat = (getSongPosition() / 1000)*(bpm/100)
    for a = 0, getProperty('notes.length') - 1 do
        strumTime = getPropertyFromGroup('notes', a, 'strumTime')
		Os = getPropertyFromGroup('notes', a, 'isSustainNote')
        if getPropertyFromGroup('notes', a, 'noteType') == 'GoFasttrolled' then
			if Os then
				setPropertyFromGroup('notes', a, 'offsetY', getPropertyFromGroup('notes', a, 'offsetY') + 2 * math.cos((currentBeat + a * 0.15) * math.pi))
			end
			if (strumTime - songPos) < 900 / scrollSpeed and not Os then
				if getPropertyFromGroup('notes', a, 'offsetY') ~= oFY then
					setPropertyFromGroup('notes', a, 'offsetY', lerp(getPropertyFromGroup('notes', a, 'offsetY'), oFY, boundTo(el * 10, 0, 4)))     
				elseif getPropertyFromGroup('notes', a, 'offsetY') <= oFY then
					setPropertyFromGroup('notes', a, 'offsetY', oFY)
				end
			elseif (strumTime - songPos) < 1000 / scrollSpeed and Os then
				if getPropertyFromGroup('notes', a, 'offsetY') ~= OsFY then
					setPropertyFromGroup('notes', a, 'offsetY', lerp(getPropertyFromGroup('notes', a, 'offsetY'), OsFY, boundTo(el * 10, 0, 4) * math.cos))
				elseif getPropertyFromGroup('notes', a, 'offsetY') <= OsFY then
					setPropertyFromGroup('notes', a, 'offsetY', OsFY)
				end
			end
        end
    end
end

function lerp(a, b, ratio)
  return math.floor(a + ratio * (b - a))
end

function boundTo(value, min, max)
	return math.max(min, math.min(max, value))
end