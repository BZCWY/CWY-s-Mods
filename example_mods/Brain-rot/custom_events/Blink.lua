function onCreate()
	makeAnimatedLuaSprite('bfblink', 'bfblink', 0, 0);
	addAnimationByPrefix('bfblink', 'blink', 'bfblink', 36, false);
	setScrollFactor('bfblink', 0, 0);
	screenCenter('bfblink', 'xy');
	setObjectCamera('bfblink', 'hud');
	addLuaSprite('bfblink', false);
	setProperty('bfblink.alpha', 0.0001);
	precacheImage('bfblink');
	runTimer('bfblink', 1);
end

function onTimerCompleted(tag)
	if tag == 'bfblink' then
		setProperty('bfblink.alpha', 1);
	end
end

function onEvent(name, value1, value2)
	if name == 'Blink' then
		playAnim('bfblink', 'blink', true);
		setProperty('bfblink.alpha', 1);
	end
end