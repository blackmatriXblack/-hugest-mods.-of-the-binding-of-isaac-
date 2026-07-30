-- =============================================================================
--  SpittyBarrage - The Binding of Isaac: Repentance
--  Spitty fires 5 rapid IPECAC shots in a spread pattern every 4 seconds
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SpittyBarrage", 1)
local SPITTY_TYPE = 207 -- EntityType.ENTITY_SPITTY
local BARRAGE_INTERVAL = 120 -- 4 seconds
local barrageTimers = {}

local function onNPCUpdate(_, entity)
    if entity.Type ~= SPITTY_TYPE or not entity:Exists() then
        return
    end

    local idx = entity.Index
    if not barrageTimers[idx] then
        barrageTimers[idx] = BARRAGE_INTERVAL
    end

    barrageTimers[idx] = barrageTimers[idx] - 1
    if barrageTimers[idx] <= 0 then
        barrageTimers[idx] = BARRAGE_INTERVAL

        local player = Isaac.GetPlayer(0)
        if not player or not player:Exists() then return end

        local dirToPlayer = (player.Position - entity.Position):Normalized()
        local spreadAngle = math.rad(20)

        for i = 0, 4 do
            local angle = (i - 2) * spreadAngle
            local shotDir = dirToPlayer:Rotated(angle)
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0,
                entity.Position, shotDir * 8, entity)
            if tear then
                tear.CollisionDamage = 3.5
                tear.Scale = 1.2
                tear:AddTearFlags(TearFlags.TEAR_ACID) -- IPECAC-like
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("SpittyBarrage loaded!")
