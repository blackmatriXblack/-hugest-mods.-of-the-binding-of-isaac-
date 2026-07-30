-- =============================================================================
--  VomitGrimaceAcid - The Binding of Isaac: Repentance
--  Vomit Grimaces shoot corrosive acid projectiles periodically
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("VomitGrimaceAcid", 1)
local VOMIT_GRIMACE_TYPE = 849
local SHOT_INTERVAL = 90
local ACID_POOL_DURATION = 120

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= VOMIT_GRIMACE_TYPE then return end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local frame = Game():GetFrameCount()
    local player = Isaac.GetPlayer(0)

    if data.init == nil then
        data.init = true
        data.lastShot = frame + math.random(30, SHOT_INTERVAL)
        npc:AddEntityFlags(EntityFlag.FLAG_GREEN)
        npc.Velocity = Vector.Zero
    end

    -- Ensure the grimace stays stationary
    npc.Velocity = Vector.Zero

    -- Shoot acid projectile on cooldown
    if player:Exists() and frame - data.lastShot >= SHOT_INTERVAL then
        data.lastShot = frame
        local pos = npc.Position
        local dirToPlayer = (player.Position - pos):Normalized()

        -- Acid blob (larger, slower tear with acid creep)
        local acid = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.GREEN, 0,
            pos, dirToPlayer:Resized(3.5), npc):ToTear()
        if acid then
            acid:AddTearFlags(TearFlags.TEAR_ACID)
            acid:AddTearFlags(TearFlags.TEAR_GREEN)
            acid.CollisionDamage = 1.5
            acid.Scale = 1.4
            acid.FallingSpeed = -0.5
            acid.FallingAcceleration = 0.05
        end

        -- Second shot with a slight angle offset for variety
        local offsetAngle = math.atan2(dirToPlayer.Y, dirToPlayer.X) + (math.random() - 0.5) * 0.4
        local dir2 = Vector(math.cos(offsetAngle), math.sin(offsetAngle))
        local acid2 = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.GREEN, 0,
            pos, dir2:Resized(3 + math.random()), npc):ToTear()
        if acid2 then
            acid2:AddTearFlags(TearFlags.TEAR_ACID)
            acid2.CollisionDamage = 1.0
            acid2.Scale = 1.0
        end

        -- Gurgle visual effect
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TEAR_POOF_A, 0,
            pos, Vector.Zero, npc)
    end

    -- Acid pool maintenance: leave creep near the grimace
    if frame % 30 == 0 then
        local creep = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_GREEN, 0,
            npc.Position + Vector(math.random(-30, 30), math.random(-30, 30)),
            Vector.Zero, npc)
        if creep then
            creep:GetData().despawnTime = ACID_POOL_DURATION
        end
    end

    -- Clean up old acid pools
    local ents = Isaac.GetRoomEntities()
    for _, ent in ipairs(ents) do
        if ent.Type == EntityType.ENTITY_EFFECT and
           ent.Variant == EffectVariant.PLAYER_CREEP_GREEN then
            local cdata = ent:GetData()
            if cdata.despawnTime then
                cdata.despawnTime = cdata.despawnTime - 1
                if cdata.despawnTime <= 0 then
                    ent:Remove()
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("VomitGrimaceAcid loaded!")
