-- =============================================================================
--  FishBoneShooter - The Binding of Isaac: Repentance
--  Bony enemies shoot bone projectiles that splinter into shrapnel
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FishBoneShooter", 1)
local BONY_TYPE = 227          -- EntityType.ENTITY_BONY (bone enemy from Corpse)
local SHOT_INTERVAL = 100      -- Fire every ~3.3 seconds

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= BONY_TYPE then return end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local frame = Game():GetFrameCount()
    local player = Isaac.GetPlayer(0)

    -- Initialize
    if data.init == nil then
        data.init = true
        data.lastShot = frame + math.random(30, 90)
        npc:AddEntityFlags(EntityFlag.FLAG_SLOW)
    end

    -- Fire bone splinter shot on cooldown
    if player:Exists() and frame - data.lastShot >= SHOT_INTERVAL then
        data.lastShot = frame
        local pos = npc.Position
        local dirToPlayer = (player.Position - pos):Normalized()

        -- Primary bone projectile
        local bone = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BONE, 0,
            pos, dirToPlayer:Resized(6), npc):ToTear()
        if bone then
            bone:AddTearFlags(TearFlags.TEAR_BONE)
            bone.CollisionDamage = 2.0
            bone.Scale = 1.3
            bone.FallingSpeed = 0
            bone.FallingAcceleration = 0

            -- Store data for splintering (track lifetime)
            local bdata = bone:GetData()
            bdata.lifetime = 0
            bdata.maxLifetime = 25  -- ~0.8 seconds before splintering
        end
    end

    -- Process existing bone tears for splintering
    local room = Game():GetRoom()
    local ents = Isaac.GetRoomEntities()
    for _, ent in ipairs(ents) do
        if ent.Type == EntityType.ENTITY_TEAR and ent.Variant == TearVariant.BONE then
            local tear = ent:ToTear()
            if tear then
                local bdata = tear:GetData()
                if bdata.lifetime ~= nil then
                    bdata.lifetime = bdata.lifetime + 1
                    if bdata.lifetime >= bdata.maxLifetime then
                        -- Splinter into 3 smaller bone shards
                        local splinterpos = tear.Position
                        for j = 1, 3 do
                            local angle = (j / 3) * math.pi * 2 + math.random() * 0.5
                            local dir = Vector(math.cos(angle), math.sin(angle))
                            local shard = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BONE, 0,
                                splinterpos, dir:Resized(4 + math.random() * 2), npc):ToTear()
                            if shard then
                                shard:AddTearFlags(TearFlags.TEAR_BONE)
                                shard.CollisionDamage = 0.8
                                shard.Scale = 0.7
                                shard.FallingSpeed = 0
                                shard.FallingAcceleration = 0
                            end
                        end
                        tear:Remove()
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("FishBoneShooter loaded!")
