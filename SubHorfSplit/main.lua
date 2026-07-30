-- =============================================================================
--  SubHorfSplit - The Binding of Isaac: Repentance
--  Sub Horf fires 3-way spread shots instead of single shot
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SubHorfSplit", 1)
local SUB_HORF_TYPE = 217
local FIRE_INTERVAL = 40
local SPREAD_ANGLE = 0.35 -- radians (~20 degrees)

function mod:OnNPCUpdate(npc)
    if npc.Type ~= SUB_HORF_TYPE then return end

    local data = npc:GetData()
    data.shotTimer = (data.shotTimer or 0) + 1

    if data.shotTimer >= FIRE_INTERVAL then
        data.shotTimer = 0
        local player = Isaac.GetPlayer(0)
        if not player then return end

        local baseDir = (player.Position - npc.Position):Normalized()

        -- Fire 3-way spread
        local angles = {-SPREAD_ANGLE, 0, SPREAD_ANGLE}
        for _, angleOffset in ipairs(angles) do
            local cosA = math.cos(angleOffset)
            local sinA = math.sin(angleOffset)
            local dirX = baseDir.X * cosA - baseDir.Y * sinA
            local dirY = baseDir.X * sinA + baseDir.Y * cosA
            local shotDir = Vector(dirX, dirY)
            local spawnPos = npc.Position + shotDir * 20

            Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0,
                spawnPos, shotDir * 5, npc)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("SubHorfSplit loaded!")
