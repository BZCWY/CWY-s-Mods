function onCreatePost()
 
	initLuaShader("old")

	if shadersEnabled == true then
		makeLuaSprite("shaderImage")
		makeGraphic("shaderImage", screenWidth, screenHeight)
	end
	
	setSpriteShader("shaderImage", "old")

    addHaxeLibrary("ShaderFilter", "openfl.filters")
	runHaxeCode([[
	trace(ShaderFilter);
	game.camGame.setFilters([new ShaderFilter(game.getLuaObject("shaderImage").shader)]);
	//game.camHUD.setFilters([new ShaderFilter(game.getLuaObject("shaderImage").shader)]);
	]])
end

function onUpdate()
    setShaderFloat("shaderImage", "iTime", os.clock())
end

--[[
    if you use crt, monitor remove game.camHUD

]]