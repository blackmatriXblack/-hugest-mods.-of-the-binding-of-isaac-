-- =============================================================================
--  CrossStoneyLaser - The Binding of Isaac: Repentance
--  Cross Stoney fires 4-way brimstone lasers when player is in line of sight
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CrossStoneyLaser", 1)
local CROSS_STONEY_TYPE = 303 -- EntityType.ENTITY_CROSS_STONEY
local LASER_INTERVAL = 120 -- frames between laser bursts
local LASER_DURATION = 30
local laserTimers = {}

local function hasLineOfSight(sourcePos, targetPos)
    -- Simple line of sight check using room geometry
    local room = Game():GetRoom()
    if not room then return false end

    -- Check if target is within reasonable range
    local dist = sourcePos:Distance(targetPos)
    if dist > 400 then return false end

    -- Check cardinal axis alignment
    local dx = math.abs(sourcePos.X - targetPos.X)
    local dy = math.abs(sourcePos.Y - targetPos.Y)

    -- Cross Stoney fires on cardinal directions if aligned
    return dx < 60 or dy < 60
end

local function onNPCUpdate(_, entity)
    if entity.Type ~= CROSS_STONEY_TYPE or not entity:Exists() then
        return
    end

    local idx = entity.Index
    if not laserTimers[idx] then
        laserTimers[idx] = {timer = LASER_INTERVAL, firing = 0}
    end

    local data = laserTimers[idx]
    local player = Isaac.GetPlayer(0)
    if not player or not player:Exists() then return end

    if data.firing > 0 then
        data.firing = data.firing - 1
    else
        data.timer = data.timer - 1
    end

    if data.timer <= 0 and hasLineOfSight(entity.Position, player.Position) then
        data.timer = LASER_INTERVAL
        data.firing = LASER_DURATION

        local pos = entity.Position
        -- Fire 4-way brimstone lasers
        local directions = {
            Vector(1, 0), Vector(-1, 0), Vector(0, 1), Vector(0, -1)
        }
        for _, dir in ipairs(directions) do
            local laser = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALLOWEEN_LASER, 0,
                pos, dir * 10, entity)
            if laser then
                laser.CollisionDamage = 1.5
                laser.DepthOffset = -10
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("CrossStoneyLaser loaded!")
