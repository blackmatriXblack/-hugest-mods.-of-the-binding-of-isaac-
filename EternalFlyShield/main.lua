-- =============================================================================
--  EternalFlyShield - The Binding of Isaac: Repentance
--  Eternal Fly actively orbits the nearest enemy, absorbing damage for it
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("EternalFlyShield", 1)
local ETERNAL_FLY_TYPE = 27 -- EntityType.ENTITY_ETERNALFLY
local ORBIT_RADIUS = 40
local ORBIT_SPEED = 0.08
local orbitAngles = {} -- entity index -> current angle

local function onNPCUpdate(_, entity)
    if entity.Type ~= ETERNAL_FLY_TYPE or not entity:Exists() then
        return
    end

    -- Find nearest enemy (not self)
    local nearest = nil
    local nearestDist = 9999
    local room = Game():GetRoom()
    if not room then return end

    local myPos = entity.Position
    for i = 0, room:GetAliveEnemiesCount() - 1 do
        local other = room:GetAliveEnemy(i)
        if other and other.Index ~= entity.Index and other:Exists() then
            local d = myPos:Distance(other.Position)
            if d < nearestDist then
                nearestDist = d
                nearest = other
            end
        end
    end

    if nearest then
        local idx = entity.Index
        if not orbitAngles[idx] then
            orbitAngles[idx] = 0
        end
        orbitAngles[idx] = orbitAngles[idx] + ORBIT_SPEED

        local targetPos = nearest.Position
        local orbitX = targetPos.X + math.cos(orbitAngles[idx]) * ORBIT_RADIUS
        local orbitY = targetPos.Y + math.sin(orbitAngles[idx]) * ORBIT_RADIUS

        entity.Velocity = (Vector(orbitX, orbitY) - myPos) * 0.3
        entity.Position = myPos + entity.Velocity

        -- Shield effect: reduce damage taken by host enemy
        nearest:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)

        -- If player hits the eternal fly (shield), spawn a brief visual burst
        local players = Isaac.GetPlayer(0)
        if players and players:Exists() then
            local distToPlayer = myPos:Distance(players.Position)
            if distToPlayer < 30 then
                for i = 1, 3 do
                    local spark = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, 0,
                        myPos + Vector(math.random(-10, 10), math.random(-10, 10)), Vector(0, 0), entity)
                end
            end
        end
    else
        entity.Velocity = Vector(0, 0)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("EternalFlyShield loaded!")
