-- =============================================================================
--  MawSwallow — The Binding of Isaac: Repentance
--  Maws (Type=14) pull player toward them when within 120 distance.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MawSwallow", 1)

local PULL_DISTANCE = 120
local PULL_STRENGTH = 0.8

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent.Type == 14 and ent:IsVulnerableEnemy() then
            local dist = ent.Position:Distance(player.Position)
            if dist < PULL_DISTANCE then
                local dir = (ent.Position - player.Position):Normalized()
                player.Velocity = player.Velocity + dir * PULL_STRENGTH
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("MawSwallow loaded!")
