-- =============================================================================
--  CrossFireEye - The Binding of Isaac: Repentance
--  Bloodshot Eyes fire a deadly 4-directional cross-fire pattern
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CrossFireEye", 1)
local EYE_TYPE = 60           -- EntityType.ENTITY_BLOODSHOT_EYE / ENTITY_EYE
local SHOT_INTERVAL = 75      -- Fire every 75 frames (2.5 seconds at 30fps)

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= EYE_TYPE then return end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local frame = Game():GetFrameCount()

    -- Initialize
    if data.init == nil then
        data.init = true
        data.lastShot = frame + math.random(0, SHOT_INTERVAL)  -- Stagger shots
    end

    -- Fire 4-directional cross fire on cooldown
    if frame - data.lastShot >= SHOT_INTERVAL then
        data.lastShot = frame
        local pos = npc.Position
        local player = Isaac.GetPlayer(0)

        -- 4 cardinal directions
        local directions = {
            Vector(1, 0),   -- Right
            Vector(-1, 0),  -- Left
            Vector(0, 1),   -- Down
            Vector(0, -1)   -- Up
        }

        for _, dir in ipairs(directions) do
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                pos, dir:Resized(4), npc):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_BLOOD)
                tear.CollisionDamage = 1.5
                tear.Scale = 1.2
                tear.FallingSpeed = 0
                tear.FallingAcceleration = -0.01
            end
        end

        -- Also fire a slower shot aimed at player if available
        if player:Exists() then
            local dirToPlayer = (player.Position - pos):Normalized()
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                pos, dirToPlayer:Resized(3.5), npc):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_BLOOD)
                tear.CollisionDamage = 1.0
                tear.Scale = 1.0
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("CrossFireEye loaded!")
