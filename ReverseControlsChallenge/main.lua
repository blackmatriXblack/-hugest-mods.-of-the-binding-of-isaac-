-- ==========================================================================
--  Reverse Controls Challenge - The Binding of Isaac: Repentance
--  Movement controls are permanently reversed — up is down, left is right
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ReverseControlsChallenge", 1)
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, function(_, player)
    -- Reverse the velocity vector to flip controls
    local vel = player.Velocity
    -- The input system adds velocity in a direction; we invert it
    player.Velocity = vel * -1

    -- Also flip shooting direction
    local shootVec = player:GetShootingInput()
    if shootVec:Length() > 0 then
        player:SetShootingInput(-shootVec)
    end
end)

Isaac.DebugString("Reverse Controls Challenge loaded!")
