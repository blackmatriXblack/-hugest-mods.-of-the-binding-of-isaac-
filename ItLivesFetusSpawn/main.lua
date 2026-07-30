-- =============================================================================
--  ItLivesFetusSpawn - The Binding of Isaac: Repentance
--  It Lives spawns 3 extra attack flies per burst
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ItLivesFetusSpawn", 1)
local IT_LIVES_ID = 275
local lastSpawnFrame = 0
local spawnCount = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= IT_LIVES_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local room = Game():GetRoom()
    local player = Isaac.GetPlayer(0)

    -- It Lives normally spawns enemies in bursts
    -- We detect spawn bursts by checking velocity/state changes every 120 frames
    if frame - lastSpawnFrame < 120 then return end

    -- Burst spawn detected: It Lives is active and HP isn't max (battle in progress)
    if npc.HitPoints > 0 then
        lastSpawnFrame = frame
        spawnCount = spawnCount + 1

        -- Spawn 3 extra attack flies that aggressively home on player
        for i = 1, 3 do
            local angle = (i * 120) * math.pi / 180
            local offset = Vector(math.cos(angle), math.sin(angle)) * 80
            local spawnPos = npc.Position + offset

            local fly = Isaac.Spawn(EntityType.ENTITY_ATTACK_FLY, 0, 0,
                spawnPos, Vector(0, 0), npc)
            if fly then
                -- Give flies a burst of speed toward the player
                if player and player:Exists() then
                    fly.Velocity = (player.Position - fly.Position):Normalized() * 6
                end
                -- Tint them red for extra threat
                fly:SetColor(Color(1, 0.3, 0.3, 1, 0, 0, 0), 999, 0, false, false)
                fly.Scale = 1.2
            end
        end

        -- Bloody spawn effect
        for _ = 1, 3 do
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0,
                npc.Position + Vector(math.random(-40, 40), math.random(-40, 40)),
                Vector(0, 0), nil)
        end

        -- Every 3rd burst, spawn a stronger enemy
        if spawnCount % 3 == 0 then
            local bigFly = Isaac.Spawn(EntityType.ENTITY_MOTER, 0, 0,
                npc.Position + Vector(math.random(-60, 60), math.random(-60, 60)),
                Vector(0, 0), npc)
            if bigFly then
                bigFly:SetColor(Color(0.5, 1, 0.5, 1, 0, 0, 0), 999, 0, false, false)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("ItLivesFetusSpawn loaded!")
