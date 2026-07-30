-- =============================================================================
--  BubblesPop - The Binding of Isaac: Repentance
--  Bubbles enemy pops into 3 small drifting bubbles on death
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BubblesPop", 1)
local BUBBLES_TYPE = 270
local BUBBLE_CHILD_COUNT = 3
local BUBBLE_LIFETIME = 120 -- frames before despawn
local BUBBLE_SPEED = 3.0

function mod:OnNPCDeath(npc)
    if npc.Type ~= BUBBLES_TYPE then return end

    -- Spawn 3 small bubbles that drift outward and damage player
    local angles = {0, 2.094, 4.188} -- 0, 120, 240 degrees

    for i = 1, BUBBLE_CHILD_COUNT do
        local angle = angles[i] + math.random() * 0.5
        local dir = Vector(math.cos(angle), math.sin(angle))
        local spawnPos = npc.Position + dir * 15

        -- Spawn a small bubble as a projectile or small enemy
        local bubble = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, spawnPos, dir * BUBBLE_SPEED, npc)
        if bubble then
            local proj = bubble:ToProjectile()
            if proj then
                proj.Height = -10
                proj.DepthOffset = 5
                proj.FallingSpeed = -4
                proj.FallingAccel = 0.3
            end
        end
    end
end

function mod:OnNPCUpdate(npc)
    if npc.Type ~= BUBBLES_TYPE then return end

    -- Bubbles drift upward slightly when alive (visual flair)
    local data = npc:GetData()
    data.floatPhase = (data.floatPhase or 0) + 0.03
    npc.Velocity = npc.Velocity + Vector(0, math.sin(data.floatPhase) * 0.15)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.OnNPCDeath)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("BubblesPop loaded!")
