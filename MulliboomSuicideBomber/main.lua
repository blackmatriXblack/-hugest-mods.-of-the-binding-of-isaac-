-- =============================================================================
--  MulliboomSuicideBomber — The Binding of Isaac: Repentance
--  Mullibooms (Type=8) rush toward player at 3x speed when within 200 distance.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MulliboomSuicideBomber", 1)

local AGRO_DISTANCE = 200
local SPEED_MULTIPLIER = 3

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= 8 then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local dist = npc.Position:Distance(player.Position)
    if dist < AGRO_DISTANCE then
        local dir = (player.Position - npc.Position):Normalized()
        npc.Velocity = dir * (npc.Velocity:Length() * SPEED_MULTIPLIER + 2)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("MulliboomSuicideBomber loaded!")
