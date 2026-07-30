-- =============================================================================
--  Little Horn Shadow Ball - The Binding of Isaac: Repentance
--  Little Horn's shadow ball attack also fires 3 spread shots on impact
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LittleHornShadowBall", 1)
local LITTLE_HORN_TYPE = 404 -- EntityType.ENTITY_LITTLE_HORN

local trackedBalls = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= LITTLE_HORN_TYPE then return end
    
    -- Track shadow ball projectiles spawned near Little Horn
    local roomEntities = Isaac.GetRoomEntities()
    for _, ent in ipairs(roomEntities) do
        if ent.Type == EntityType.ENTITY_PROJECTILE and ent.Variant == 0 then
            local proj = ent:ToProjectile()
            if proj and not trackedBalls[ent.InitSeed] then
                -- Check if it's a shadow ball (dark projectile from Little Horn)
                local dist = npc.Position:Distance(ent.Position)
                if dist < 120 and ent.FrameCount <= 5 then
                    trackedBalls[ent.InitSeed] = true
                end
            end
        end
    end
    
    -- Check for tracked balls that are about to die
    for seed, _ in pairs(trackedBalls) do
        for _, ent in ipairs(roomEntities) do
            if ent.InitSeed == seed and ent:Exists() then
                local proj = ent:ToProjectile()
                if proj and proj.FallingSpeed > 0 and ent.FrameCount > 5 then
                    -- Shadow ball impacting - fire 3 spread shots
                    local baseAngle = math.atan2(
                        ent.Velocity.Y, ent.Velocity.X
                    )
                    for j = -1, 1 do
                        local angle = baseAngle + j * 0.35
                        local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0,
                            ent.Position,
                            Vector(math.cos(angle) * 4, math.sin(angle) * 4),
                            npc)
                        if tear then
                            tear:ToProjectile().Scale = 0.7
                        end
                    end
                    trackedBalls[seed] = nil
                    break
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, LITTLE_HORN_TYPE)
Isaac.DebugString("LittleHornShadowBall loaded!")
