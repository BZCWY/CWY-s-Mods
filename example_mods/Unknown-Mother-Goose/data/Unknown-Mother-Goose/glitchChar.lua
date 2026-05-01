local targetChar = "dad"
local glitchActive = false

function onCreatePost()
    initLuaShader("glitch")
end

function onUpdate(elapsed)
    if glitchActive then
        setShaderFloat(targetChar, "iTime", os.clock())
    end
end

function onStepHit()
    if curStep == 289 then
        glitchActive = true
        setSpriteShader(targetChar, "glitch")
        setShaderFloat(targetChar, "iTime", 0)
    end

    if curStep == 3185 then
        glitchActive = false
        removeCharShader(targetChar)
    end
end

function removeCharShader(charName)
    -- 根据角色名称映射到 Haxe 中的变量名
    local haxeVar = "game.dad"
    if charName == "boyfriend" then
        haxeVar = "game.boyfriend"
    elseif charName == "gf" then
        haxeVar = "game.gf"
    end

    runHaxeCode([[
        var character = ]] .. haxeVar .. [[;
        if (character != null) {
            character.shader = null;
        }
    ]])
end