-- =============================================================================
--  MegaSatanHands - The Binding of Isaac: Repentance
--  Mega Satan's hands spawn mini dark enemies each time they slam
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MegaSatanHands", 1)
local MEGA_SATAN_HAND_LEFT = 483
local MEGA_SATAN_HAND_RIGHT = 484
local lastSlamFrame = {left = 0, right = 0}
local prevY = {}

local MINION_TYPES = {
    {type = EntityType.ENTITY_ATTACK_FLY, variant = 0},
    {type = EntityType.ENTITY_NULL, variant = 0},
    {type = EntityType.ENTITY_VIS, variant = 0},
    {type = EntityType.ENTITY_KNIGHT, variant = 0},
}

function mod:OnNPCUpdate(npc)
    local isLeft = (npc.Type == MEGA_SATAN_HAND_LEFT)
    local isRight = (npc.Type == MEGA_SATAN_HAND_RIGHT)
    if not isLeft and not isRight then return end
    if not npc:IsActiveEnemy() then return end

    local idx = npc.Index
    local key = isLeft and "left" or "right"

    -- Track vertical position to detect slam (rapid downward movement)
    if not prevY[idx] or prevY[idx] == 0 then
        prevY[idx] = npc.Position.Y
        return
    end

    local dy = npc.Position.Y - prevY[idx]
    local frame = Game():GetFrameCount()

    -- Detect slam: rapid downward movement (>8 units in one frame)
    if dy > 8 and frame - lastSlamFrame[key] > 30 then
        lastSlamFrame[key] = frame

        -- Spawn 2-3 mini dark enemies at the impact point
        local count = math.random(2, 3)
        for _ = 1, count do
            local spawn = MINION_TYPES[math.random(1, #MINION_TYPES)]
            local spawnPos = npc.Position + Vector(math.random(-40, 40), math.random(-40, 40))
            local enemy = Isaac.Spawn(spawn.type, spawn.variant, 0,
                spawnPos, Vector(0, 0), npc)

            if enemy then
                -- Make them smaller and make them target the player
                enemy:AddEntityFlags(EntityFlag.FLAG_CHARM)
                -- Tint them dark
                enemy:SetColor(Color(0.3, 0.3, 0.3, 1, 0, 0, 0), 999, 0, false, false)
            end
        end

        -- Impact effect
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0,
            npc.Position, Vector(0, 0), nil)
    end

    prevY[idx] = npc.Position.Y
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("MegaSatanHands loaded!")
