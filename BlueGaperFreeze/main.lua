-- =============================================================================
--  BlueGaperFreeze - The Binding of Isaac: Repentance
--  Blue Gaper fires ice shots that slow the player on hit
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BlueGaperFreeze", 1)
local BLUE_GAPER_TYPE = 5
local BLUE_GAPER_VARIANT = 10
local ICE_SHOT_INTERVAL = 40
local SLOW_DURATION = 60

function mod:OnNPCUpdate(npc)
    if npc.Type ~= BLUE_GAPER_TYPE or npc.Variant ~= BLUE_GAPER_VARIANT then return end

    local data = npc:GetData()
    data.shotTimer = (data.shotTimer or 0) + 1

    -- Fire ice shot toward the player periodically
    if data.shotTimer >= ICE_SHOT_INTERVAL then
        data.shotTimer = 0
        local player = Isaac.GetPlayer(0)
        if player then
            local dir = (player.Position - npc.Position):Normalized()
            local spawnPos = npc.Position + dir * 20
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, spawnPos, dir * 5, npc):ToTear()
            if tear then
                tear.CollisionDamage = npc.CollisionDamage * 0.7
            end
        end
    end

    -- Contact slow: if player touches Blue Gaper, apply ice slow
    local player = Isaac.GetPlayer(0)
    if player and player.Position:Distance(npc.Position) < 45 then
        player:AddSlowing(EntityRef(npc), SLOW_DURATION, 0.4, 0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("BlueGaperFreeze loaded!")
