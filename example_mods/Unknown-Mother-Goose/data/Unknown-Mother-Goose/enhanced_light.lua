-- Melancholy light shader for Unknown-Mother-Goose
-- Activates after blackwhite shader is removed (step 3185)
-- Only applied to camGame so arrows (camHUD) are NOT affected

local elActive = false
local elFadeIn = false
local elFadeTimer = 0.0
local FADE_DURATION = 2.0  -- slower fade for mood

function onCreatePost()
    initLuaShader("enhanced_light")

    makeLuaSprite("elShader")
    setSpriteShader("elShader", "enhanced_light")
    makeGraphic("elShader", screenWidth, screenHeight)

    -- Defaults (inactive)
    setShaderFloat("elShader", "intensity", 0.0)
    setShaderFloat("elShader", "contrast", 1.0)
    setShaderFloat("elShader", "desaturation", 0.0)
    setShaderFloat("elShader", "blueTint", 0.0)
    setShaderFloat("elShader", "vignetteStrength", 0.0)
    setShaderFloat("elShader", "shadowDepth", 0.0)
    setShaderFloat("elShader", "grainAmount", 0.0)
end

function activateEnhancedLight()
    if elActive then return end
    elActive = true
    elFadeIn = true
    elFadeTimer = 0.0

    -- Only apply to camGame (not camHUD) so arrows stay clean
    runHaxeCode([[
        var shaderSprite = game.getLuaObject("elShader");
        if (shaderSprite != null && shaderSprite.shader != null) {
            var filter = new ShaderFilter(shaderSprite.shader);
            game.camGame.setFilters([filter]);
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

function onUpdate(elapsed)
    if not elFadeIn then return end

    elFadeTimer = elFadeTimer + elapsed
    local t = math.min(elFadeTimer / FADE_DURATION, 1.0)
    local ease = 1.0 - math.pow(1.0 - t, 3)

    local con    = 1.0 + ease * 0.35      -- 1.0 -> 1.35 (contrast)
    local desat  = ease * 0.3             -- 0.0 -> 0.3 (desaturation)
    local blue   = ease * 0.45            -- 0.0 -> 0.45 (cold blue tint)
    local vig    = ease * 0.85            -- 0.0 -> 0.85 (heavy vignette)
    local shadow = ease * 0.6             -- 0.0 -> 0.6 (deepen blacks)
    local grain  = ease * 0.06            -- 0.0 -> 0.06 (subtle film grain)

    setShaderFloat("elShader", "contrast", con)
    setShaderFloat("elShader", "desaturation", desat)
    setShaderFloat("elShader", "blueTint", blue)
    setShaderFloat("elShader", "vignetteStrength", vig)
    setShaderFloat("elShader", "shadowDepth", shadow)
    setShaderFloat("elShader", "grainAmount", grain)
    setShaderFloat("elShader", "intensity", ease)

    if t >= 1.0 then
        elFadeIn = false
    end
end

function onStepHit()
    if curStep == 3185 then
        runTimer("elStart", 0.05, 1)
    end
end

function onTimerCompleted(tag)
    if tag == "elStart" then
        activateEnhancedLight()
    end
end

function setEnhancedLightIntensity(value)
    setShaderFloat("elShader", "intensity", value)
    setShaderFloat("elShader", "contrast", 1.0 + value * 0.35)
    setShaderFloat("elShader", "desaturation", value * 0.3)
    setShaderFloat("elShader", "blueTint", value * 0.45)
    setShaderFloat("elShader", "vignetteStrength", value * 0.85)
    setShaderFloat("elShader", "shadowDepth", value * 0.6)
    setShaderFloat("elShader", "grainAmount", value * 0.06)
end
