function onCreatePost()
    initLuaShader("blackwhite")

    makeLuaSprite("bwShader")
    setSpriteShader("bwShader", "blackwhite")
    makeGraphic("bwShader", screenWidth, screenHeight)

    setShaderFloat("bwShader", "grayness", 1.0)

    runHaxeCode([[
        var shaderSprite = game.getLuaObject("bwShader");
        if (shaderSprite != null && shaderSprite.shader != null) {
            var filter = new ShaderFilter(shaderSprite.shader);
            game.camGame.setFilters([filter]);   
            game.camHUD.setFilters([filter]);   
        }
    ]])

    shaderCoordFix()
end

function shaderCoordFix()
    runHaxeCode([[
        resetCamCache = function(?spr) {
            if (spr == null || spr.filters == null) return;
            spr.__cacheBitmap = null;
            spr.__cacheBitmapData = null;
        }
        
        fixShaderCoordFix = function(?_) {
            resetCamCache(game.camGame.flashSprite);
            resetCamCache(game.camHUD.flashSprite);
            resetCamCache(game.camOther.flashSprite);
        }
    
        FlxG.signals.gameResized.add(fixShaderCoordFix);
        fixShaderCoordFix();
        return;
    ]])
    
    local temp = onDestroy
    function onDestroy()
        runHaxeCode([[
            FlxG.signals.gameResized.remove(fixShaderCoordFix);
            return;
        ]])
        if (temp) then temp() end
    end
end

function setGrayness(value)
    setShaderFloat("bwShader", "grayness", value)
end

function onUpdate(elapsed)
end

function onStepHit()
    if curStep == 3185 then
        runHaxeCode([[
            game.camGame.setFilters([]);
            game.camHUD.setFilters([]);
        ]])
    end
end