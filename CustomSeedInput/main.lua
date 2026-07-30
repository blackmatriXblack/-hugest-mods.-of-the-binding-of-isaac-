-- =============================================================================
--  CustomSeedInput - The Binding of Isaac: Repentance
--  Custom seed input with hotkey — press S to type a seed on any menu
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CustomSeedInput", 1)
local inputActive = false
local seedBuffer = ""
local feedbackMsg = ""
local feedbackTimer = 0

local function CharToKeyCode(c)
    local upper = string.upper(c)
    local codes = {
        A=97, B=98, C=99, D=100, E=101, F=102, G=103, H=104,
        I=105, J=106, K=107, L=108, M=109, N=110, O=111, P=112,
        Q=113, R=114, S=115, T=116, U=117, V=118, W=119, X=120,
        Y=121, Z=122,
        ["0"]=48, ["1"]=49, ["2"]=50, ["3"]=51, ["4"]=52,
        ["5"]=53, ["6"]=54, ["7"]=55, ["8"]=56, ["9"]=57,
    }
    return codes[upper]
end

function mod:onUpdate()
    if Input.IsButtonPressed(Keyboard.KEY_S, 0) then
        inputActive = not inputActive
        if inputActive then
            seedBuffer = ""
            feedbackMsg = "Enter seed (8 chars A-Z 0-9, ENTER to confirm, ESC to cancel)"
            feedbackTimer = 0
        else
            seedBuffer = ""
            feedbackMsg = ""
        end
    end

    if not inputActive then
        if feedbackTimer > 0 then
            feedbackTimer = feedbackTimer - 1
            if feedbackTimer <= 0 then feedbackMsg = "" end
        end
        return
    end

    -- Process key inputs
    for _, c in ipairs({"A","B","C","D","E","F","G","H","I","J","K","L","M",
                        "N","O","P","Q","R","S","T","U","V","W","X","Y","Z",
                        "0","1","2","3","4","5","6","7","8","9"}) do
        if Input.IsButtonPressed(CharToKeyCode(c), 0) and #seedBuffer < 8 then
            -- Skip S since it toggles
            if c ~= "S" then
                seedBuffer = seedBuffer .. c
                feedbackMsg = "Seed: " .. seedBuffer
            end
        end
    end

    -- Backspace
    if Input.IsButtonPressed(Keyboard.KEY_BACKSPACE, 0) and #seedBuffer > 0 then
        seedBuffer = string.sub(seedBuffer, 1, -2)
        feedbackMsg = "Seed: " .. seedBuffer
    end

    -- Confirm
    if Input.IsButtonPressed(Keyboard.KEY_ENTER, 0) then
        if #seedBuffer >= 1 then
            local game = Game()
            -- Pad to 8 characters
            local seed = seedBuffer
            while #seed < 8 do seed = seed .. "0" end
            local success = game:StartSeed(seed)
            if success then
                feedbackMsg = "Starting run with seed: " .. seed
                feedbackTimer = 120
                inputActive = false
                seedBuffer = ""
            else
                feedbackMsg = "Failed to start seed: " .. seed
                feedbackTimer = 90
            end
        end
    end

    -- Cancel
    if Input.IsButtonPressed(Keyboard.KEY_ESCAPE, 0) then
        inputActive = false
        seedBuffer = ""
        feedbackMsg = "Seed input cancelled"
        feedbackTimer = 60
    end
end

function mod:onRender()
    if inputActive then
        local font = Font()
        local displaySeed = seedBuffer
        while #displaySeed < 8 do displaySeed = displaySeed .. "_" end
        font:DrawString("ENTER SEED: " .. displaySeed,
            Isaac.GetScreenWidth() * 0.3, Isaac.GetScreenHeight() * 0.45,
            KColor(0.3, 1, 0.3, 1), 0, false)
        font:DrawString("A-Z, 0-9 | ENTER=Confirm | ESC=Cancel | BACKSPACE=Delete",
            Isaac.GetScreenWidth() * 0.2, Isaac.GetScreenHeight() * 0.55,
            KColor(1, 1, 1, 0.7), 0, false)
    end

    if feedbackMsg ~= "" and not inputActive then
        local font = Font()
        font:DrawString(feedbackMsg,
            Isaac.GetScreenWidth() * 0.3, Isaac.GetScreenHeight() * 0.5,
            KColor(1, 1, 0, 1), 0, false)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("CustomSeedInput loaded!")
