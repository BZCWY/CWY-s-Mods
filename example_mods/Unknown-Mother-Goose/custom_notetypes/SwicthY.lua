--Creator
--Idea by MoonScarf
--Created by Kevin Kuntz
--Modified by ThisIsVerdi
local offsetYy = {-360,360}
function onCreatePost()
	for i = 0, getProperty('unspawnNotes.length') - 1 do
		sus = getPropertyFromGroup('unspawnNotes', i, 'isSustainNote')
		mustPress = getPropertyFromGroup('unspawnNotes', i, 'mustPress')
		if getPropertyFromGroup('unspawnNotes', i, 'noteType') == 'SwicthY' then
			if not sus then
				oFY = getPropertyFromGroup('unspawnNotes', i, 'offsetY')
			else
				susFY = getPropertyFromGroup('unspawnNotes', i, 'offsetY')
			end
			if mustPress then
				setPropertyFromGroup('unspawnNotes', i, 'offsetY', getPropertyFromGroup('unspawnNotes', i, 'offsetY') - offsetYy[(downscroll and 1 or 2)])
				setPropertyFromGroup('unspawnNotes', i, 'offsetAngle', getPropertyFromGroup('unspawnNotes', i, 'offsetAngle') - 360)
			else
				setPropertyFromGroup('unspawnNotes', i, 'offsetY', getPropertyFromGroup('unspawnNotes', i, 'offsetY') - offsetYy[(downscroll and 1 or 2)])
				setPropertyFromGroup('unspawnNotes', i, 'offsetAngle', getPropertyFromGroup('unspawnNotes', i, 'offsetAngle') - 360)
			end
        end
    end
end

function onUpdatePost(el)
    songPos = getSongPosition()
	local currentBeat = (getSongPosition() / 1000)*(bpm/100)
    for a = 0, getProperty('notes.length') - 1 do
        strumTime = getPropertyFromGroup('notes', a, 'strumTime')
		sus = getPropertyFromGroup('notes', a, 'isSustainNote')
        if getPropertyFromGroup('notes', a, 'noteType') == 'SwicthY' then
			if sus then
				setPropertyFromGroup('notes', a, 'offsetY', getPropertyFromGroup('notes', a, 'offsetY') + 2 * math.cos((currentBeat + a * 0.15) * math.pi))
			end
			if (strumTime - songPos) < 1750 / scrollSpeed and not sus then
				if getPropertyFromGroup('notes', a, 'offsetY') ~= oFY then
					setPropertyFromGroup('notes', a, 'offsetY', lerp(getPropertyFromGroup('notes', a, 'offsetY'), oFY, boundTo(el * 6, 0, 1)))     
										setPropertyFromGroup('notes', a, 'offsetAngle', lerp(getPropertyFromGroup('notes', a, 'offsetAngle'), oFY, boundTo(el * 6, 0, 1)))                     
				elseif getPropertyFromGroup('notes', a, 'offsetY') <= oFY then
					setPropertyFromGroup('notes', a, 'offsetY', oFY)
				end
			elseif (strumTime - songPos) < 1650 / scrollSpeed and sus then
				if getPropertyFromGroup('notes', a, 'offsetY') ~= susFY then
					setPropertyFromGroup('notes', a, 'offsetY', lerp(getPropertyFromGroup('notes', a, 'offsetY'), susFY, boundTo(el * 6, 0, 1) * math.cos))
				elseif getPropertyFromGroup('notes', a, 'offsetY') <= susFY then
					setPropertyFromGroup('notes', a, 'offsetY', susFY)
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