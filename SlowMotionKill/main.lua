-- ==========================================================================
--  SlowMotionKill - The Binding of Isaac: Repentance
--  Killing an enemy triggers 1 second of slow motion — dramatic finish!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SlowMotionKill", 1)
local slowTimer = 0
local SLOW_DURATION = 30
local SLOW_FACTOR = 0.3

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if npc:IsBoss() then
        slowTimer = SLOW_DURATION * 2
        SFXManager():Play(SoundEffect.SOUND_CHALLENGE_COMPLETE, 0.5, 0, false, 0.5)
    elseif slowTimer <= 5 then
        slowTimer = math.min(SLOW_DURATION, slowTimer + 8)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    if slowTimer > 0 then
        slowTimer = slowTimer - 1
        local animSpeed = slowTimer > 5 and SLOW_FACTOR or (SLOW_FACTOR + (1 - SLOW_FACTOR) * (1 - slowTimer / 5))
        Game():SetRoomAnimationSpeed(animSpeed)

        if slowTimer == 0 then
            Game():SetRoomAnimationSpeed(1.0)
        end
    end
end)

Isaac.DebugString("SlowMotionKill loaded! Dramatic finish!")
