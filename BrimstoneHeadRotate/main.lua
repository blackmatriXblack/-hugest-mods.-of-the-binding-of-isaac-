-- =============================================================================
--  BrimstoneHeadRotate - The Binding of Isaac: Repentance
--  Brimstone laser head rotates its beam 360 degrees over time
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BrimstoneHeadRotate", 1)
local BRIMSTONE_HEAD_TYPE = 222 -- EntityType.ENTITY_BRIMSTONE_HEAD
local ROTATION_SPEED = 0.03

local function onNPCUpdate(_, entity)
    if entity.Type ~= BRIMSTONE_HEAD_TYPE or not entity:Exists() then
        return
    end

    if not entity.I2 then entity.I2 = 0 end
    entity.I2 = entity.I2 + ROTATION_SPEED

    local angle = entity.I2
    local pos = entity.Position

    -- Rotate and shoot in current direction
    local dir = Vector(math.cos(angle), math.sin(angle))
    entity.Velocity = dir * 1.5 -- slow circular movement

    -- Every 60 frames (~2 sec), fire a thin brimstone beam
    local frame = Game():GetFrameCount()
    if frame % 60 == 0 then
        local laser = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVoidal.HALLOWEEN_LASER, 0,
            pos, dir * 12, entity)
        if laser then
            laser.CollisionDamage = 2.5
            laser.DepthOffset = -20
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("BrimstoneHeadRotate loaded!")
