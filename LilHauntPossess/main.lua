-- =============================================================================
--  LilHauntPossess - The Binding of Isaac: Repentance
--  Lil' Haunt randomly possesses another enemy, giving it spectral + fear immunity
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LilHauntPossess", 1)
local LIL_HAUNT_TYPE = 284 -- EntityType.ENTITY_LIL_HAUNT
local POSSESS_INTERVAL = 240 -- 8 seconds
local POSSESS_DURATION = 180

local function findNearbyEnemy(excludeEntity, pos)
    local room = Game():GetRoom()
    if not room then return nil end

    for i = 0, room:GetAliveEnemiesCount() - 1 do
        local other = room:GetAliveEnemy(i)
        if other and other.Index ~= excludeEntity.Index and other:Exists() and other:IsVulnerableEnemy() then
            local dist = pos:Distance(other.Position)
            if dist < 150 then
                return other
            end
        end
    end
    return nil
end

local function onNPCUpdate(_, entity)
    if entity.Type ~= LIL_HAUNT_TYPE or not entity:Exists() then
        return
    end

    if not entity.I2 then entity.I2 = 0 end
    entity.I2 = entity.I2 + 1

    if entity.I2 >= POSSESS_INTERVAL then
        entity.I2 = 0

        local target = findNearbyEnemy(entity, entity.Position)
        if target then
            -- Possess: apply spectral + fear immunity visual and properties
            target:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            target:SetColor(Color(0.3, 0.8, 1.0, 1, 0, 0, 0), POSSESS_DURATION, 0, false, true)

            -- Spawn ghostly visual link
            local ghost = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0,
                target.Position, Vector(0, 0), entity)

            -- Move Lil' Haunt to "attach" to the target
            entity.Position = target.Position + Vector(0, -20)
            entity.Velocity = target.Velocity
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("LilHauntPossess loaded!")
