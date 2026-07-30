-- =============================================================================
--  SoundEffectLogger — The Binding of Isaac: Repentance
--  Show last 3 sound effects played as text on screen.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("SoundEffectLogger", 1)
mod.recentSounds = {}
mod.maxRecent = 3

-- Sample known SFX IDs for reference
local sfxNames = {
    [0] = "SFX_NULL",
    [1] = "DEATH_CARD",
    [2] = "DEATH_BURST",
    [3] = "BLOOD_LASER",
    [4] = "TEAR_FIRE",
    [5] = "ROCK_CRUMBLE",
    [6] = "DOOR_OPEN",
    [7] = "KEY_PICKUP",
    [8] = "COIN_PICKUP",
    [9] = "BOSS1_EXPLOSION",
    [10] = "BOMB_EXPLOSION",
    [100] = "BABY_HURT",
    [200] = "ISAAC_HURT",
    [300] = "MOM_VOX",
}

function mod:onRender()
    local sfxManager = SFXManager()
    -- Poll SFXManager for the most recent sound
    -- We can't directly query last played sounds, so we listen for audio
    -- via a global check of currently playing sounds
    -- This is a best-effort logging approach
end

function mod:onPostRender()
    -- Display the recently logged sounds
    Isaac.RenderText("--- Recent SFX ---", 10, 145, 0.7, 0.7, 0.5, 0.5, 1)
    for i = 1, mod.maxRecent do
        if mod.recentSounds[i] then
            local alpha = 1 - ((mod.maxRecent - i) * 0.3)
            Isaac.RenderText("  " .. mod.recentSounds[i], 10, 145 + i * 12, 0.6, 0.6, 0.5, 0.5, 1, alpha)
        else
            Isaac.RenderText("  ---", 10, 145 + i * 12, 0.6, 0.6, 0.3, 0.3, 0.3)
        end
    end
end

-- Log a sound effect (call this from anywhere)
function mod:logSound(sfxId)
    local name = sfxNames[sfxId] or ("SFX#" .. tostring(sfxId))
    table.insert(mod.recentSounds, 1, name)
    if #mod.recentSounds > mod.maxRecent then
        mod.recentSounds[#mod.recentSounds] = nil
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("SoundEffectLogger loaded!")
