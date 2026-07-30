-- =============================================================================
--  NullVoid - The Binding of Isaac: Repentance
--  Null steals nearby pickups and converts them to homing shots
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("NullVoid", 1)
local NULL_TYPE = 295 -- EntityType.ENTITY_NULL
local STEAL_RANGE = 120
local STEAL_INTERVAL = 90

local function onNPCUpdate(_, entity)
    if entity.Type ~= NULL_TYPE or not entity:Exists() then
        return
    end

    if not entity.I2 then entity.I2 = 0 end
    entity.I2 = entity.I2 + 1

    if entity.I2 >= STEAL_INTERVAL then
        entity.I2 = 0

        local pos = entity.Position
        local room = Game():GetRoom()
        if not room then return end

        -- Find and consume nearby pickups
        for i = 0, 99 do
            local pickup = Isaac.FindByType(EntityType.ENTITY_PICKUP, -1, -1, false, false)
            local found = false
            if #pickup > 0 then
                for _, pk in ipairs(pickup) do
                    if pk:Exists() and pos:Distance(pk.Position) < STEAL_RANGE then
                        pk:Remove()
                        found = true
                        break
                    end
                end
            end
            if not found then break end
        end

        -- Convert stolen pickups to homing shots
        local player = Isaac.GetPlayer(0)
        if player and player:Exists() then
            local shotCount = 3
            for i = 1, shotCount do
                local angle = (i - 1) * (math.pi * 2 / shotCount) + math.random() * 0.5
                local dir = Vector(math.cos(angle), math.sin(angle))
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, pos, dir * 4, entity)
                if tear then
                    tear:AddEntityFlags(EntityFlag.FLAG_HOME)
                    tear.CollisionDamage = 1.5
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("NullVoid loaded!")
