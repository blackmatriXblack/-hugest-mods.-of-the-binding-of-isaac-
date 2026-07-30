-- =============================================================================
--  TaintedSpitterAcid - The Binding of Isaac: Repentance
--  Tainted Spitter fires acid shots that leave green creep puddles
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedSpitterAcid", 1)
local TAINTED_SPITTER_TYPE = 278
local ACID_SHOT_INTERVAL = 55
local ACID_CREEP_VARIANT = 3 -- green/toxic creep
local ACID_CREEP_SPREAD = 3
local PROJECTILE_SPEED = 5.5

function mod:OnNPCUpdate(npc)
    if npc.Type ~= TAINTED_SPITTER_TYPE then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local data = npc:GetData()
    data.acidTimer = (data.acidTimer or 0) + 1

    if data.acidTimer >= ACID_SHOT_INTERVAL then
        data.acidTimer = 0

        -- Fire acid projectile toward player
        local dir = (player.Position - npc.Position):Normalized()
        local spawnPos = npc.Position + dir * 20

        local proj = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, spawnPos,
            dir * PROJECTILE_SPEED, npc):ToProjectile()
        if proj then
            proj.Height = -15
            proj.FallingSpeed = -1
            proj.FallingAccel = 0.15
            proj.Scale = 1.2
            proj.DepthOffset = 0
            -- Store data for creep spawning
            proj:GetData().acidProj = true
        end
    end

    -- Track acid projectiles to spawn creep where they land
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent and ent:Exists() and ent.Type == EntityType.ENTITY_PROJECTILE then
            local p = ent:ToProjectile()
            if p and p:GetData().acidProj then
                -- Check if projectile has landed (height near 0)
                if p.FallingSpeed >= 0 and p.Height >= -2 then
                    -- Spawn creep puddles around impact
                    for i = 1, ACID_CREEP_SPREAD do
                        local offX = math.random(-25, 25)
                        local offY = math.random(-25, 25)
                        local creepPos = p.Position + Vector(offX, offY)
                        Isaac.GridSpawn(GridEntityType.GRID_CREEP, ACID_CREEP_VARIANT, creepPos, true)
                    end
                    -- Also spawn directly at impact
                    Isaac.GridSpawn(GridEntityType.GRID_CREEP, ACID_CREEP_VARIANT, p.Position, true)

                    -- Acid splash visual
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF1, 0,
                        p.Position, Vector.Zero, nil)

                    -- Remove projectile after creep spawned
                    p:Die()
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("TaintedSpitterAcid loaded!")
