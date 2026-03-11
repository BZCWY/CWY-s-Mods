function onCreatePost()
	--[[setObjectCamera('comboGroup', 'camGame');
	setProperty('comboGroup.x', getProperty('dad.x'));
	setProperty('comboGroup.y', getProperty('dad.y'));]]
	
	runHaxeCode([[
		comboGroup.camera = camGame;
		comboGroup.x = gf.x;
		comboGroup.y = gf.y;
	]]);
end