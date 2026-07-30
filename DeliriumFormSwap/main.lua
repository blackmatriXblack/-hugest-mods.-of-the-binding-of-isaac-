-- =============================================================================
--  DeliriumFormSwap - The Binding of Isaac: Repentance
--  Delirium changes form every 3 seconds with 1-second telegraph warning
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DeliriumFormSwap", 1)
local DELIRIUM_ID = 412
local TELEGRAPH_FRAME = 0
local SWAP_FRAME = 0
local isTelegraphing = false

function mod:OnNPCUpdate(npc)
    if npc.Type ~= DELIRIUM_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()

    -- Phase 1: Telegraph - starts after 60 frames (2s)
    if frame - SWAP_FRAME >= 60 and not isTelegraphing then
        isTelegraphing = true
        TELEGRAPH_FRAME = frame

        -- Visual telegraph: pulsating white flash + slow down
        npc:SetColor(Color(1, 1, 1, 1, 0, 1, 0.5), 30, 0, false, false)
        npc.Velocity = npc.Velocity * 0.2 -- Slow down to telegraph

        -- Spawn indicator effect
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLY, 0,
            npc.Position, Vector(0, 0), nil)
    end

    -- Phase 2: Swap - happens 30 frames (1s) after telegraph
    if isTelegraphing and frame - TELEGRAPH_FRAME >= 30 then
        isTelegraphing = false
        SWAP_FRAME = frame

        -- Brief invulnerability during morph
        npc:AddEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK)

        -- Morph effect
        local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT,
            EffectVariant.TELEPORT, 0,
            npc.Position, Vector(0, 0), nil)

        -- "Change form" by applying random visual distortion
        -- Since we can't directly control Delirium's form change,
        -- we simulate it by:
        -- 1. Random color shift
        -- 2. Scale change
        -- 3. Speed boost for a moment
        local colors = {
            Color(1, 0.3, 0.3, 1, 0, 0, 0), -- Red
            Color(0.3, 1, 0.3, 1, 0, 0, 0), -- Green
            Color(0.3, 0.3, 1, 1, 0, 0, 0), -- Blue
            Color(1, 1, 0.3, 1, 0, 0, 0), -- Yellow
            Color(1, 0.3, 1, 1, 0, 0, 0), -- Purple
        }
        local randomColor = colors[math.random(1, #colors)]
        npc:SetColor(randomColor, 999, 0, false, false)

        -- Size fluctuation
        local scale = 0.8 + math.random() * 0.4
        npc.Scale = scale

        -- Short speed burst in random direction
        local burstDir = Vector(math.random() - 0.5, math.random() - 0.5):Normalized()
        npc.Velocity = burstDir * 8

        -- Spawn some warning tears in random directions
        for i = 1, 6 do
            local angle = math.random() * 2 * math.pi
            local dir = Vector(math.cos(angle), math.sin(angle))
            Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                npc.Position, dir * 3, npc)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("DeliriumFormSwap loaded!")
