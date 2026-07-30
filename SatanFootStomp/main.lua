-- =============================================================================
--  SatanFootStomp - The Binding of Isaac: Repentance
--  Satan's foot stomp fires 4-way blood shots on landing
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SatanFootStomp", 1)
local SATAN_ID = 84
local lastStompFrame = 0
local prevY = {}
local isStomping = {}

function mod:OnNPCUpdate(npc)
    -- Handle both Satan phases
    local isSatan = (npc.Type == SATAN_ID) or (npc.Type == 275 and npc.Variant == 10)
    if not isSatan then return end
    if not npc:IsActiveEnemy() then return end

    local idx = npc.Index
    local player = Isaac.GetPlayer(0)
    if not player or not player:Exists() then return end
    local frame = Game():GetFrameCount()

    -- Track foot stomp via vertical velocity
    if not prevY[idx] then
        prevY[idx] = npc.Position.Y
        isStomping[idx] = false
        return
    end

    local dy = npc.Position.Y - prevY[idx]

    -- Detect stomp: massive downward movement
    if dy > 15 and not isStomping[idx] and frame - lastStompFrame > 20 then
        isStomping[idx] = true
        lastStompFrame = frame

        -- Fire 4-way blood shots from each stomp position
        -- But wait until the foot has landed (velocity near zero)
    end

    -- Detect landing: rapid deceleration after stomp
    if isStomping[idx] and math.abs(dy) < 2 and npc.Velocity:Length() < 2 then
        isStomping[idx] = false

        local stompPos = npc.Position

        -- Fire blood shots in 4 cardinal directions
        local directions = {
            Vector(1, 0),   -- Right
            Vector(-1, 0),  -- Left
            Vector(0, 1),   -- Down
            Vector(0, -1),  -- Up
        }

        for _, dir in ipairs(directions) do
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                stompPos, dir * 8, npc):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_BLOOD)
                tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                tear:SetColor(Color(0.7, 0, 0, 1, 0, 0, 0), 0, 0)
                tear.Scale = 1.8
            end
        end

        -- Also fire 4 diagonal blood shots
        local diags = {
            Vector(0.707, 0.707),
            Vector(-0.707, 0.707),
            Vector(0.707, -0.707),
            Vector(-0.707, -0.707),
        }

        for _, dir in ipairs(diags) do
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                stompPos, dir * 6, npc):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_BLOOD)
                tear.Scale = 1.3
            end
        end

        -- Blood splash effect
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0,
            stompPos, Vector(0, 0), nil)

        -- Creep pool at stomp site
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0,
            stompPos, Vector(0, 0), nil)

        -- Shake it up
        Game():GetRoom():TriggerShake(4)
    end

    prevY[idx] = npc.Position.Y
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("SatanFootStomp loaded!")
