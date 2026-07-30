-- =============================================================================
--  KrampusPresent - The Binding of Isaac: Repentance
--  Krampus randomly drops presents (item pedestals) that summon enemies when touched
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("KrampusPresent", 1)
local KRAMPUS_ID = 80

-- Present pedestals are tracked with their positions
local presentPedestals = {}
local lastDropFrame = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= KRAMPUS_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local room = Game():GetRoom()

    -- Drop a "present" (pedestal item) every 300 frames (~10 seconds)
    if frame - lastDropFrame >= 300 then
        lastDropFrame = frame

        -- Choose a random position in the room
        local center = room:GetCenterPos()
        local dropPos = center + Vector(math.random(-150, 150), math.random(-100, 100))
        dropPos = room:FindFreePickupSpawnPosition(dropPos, 0, true)

        -- Spawn a random pickup as "present" (looks like an item)
        local pickupTypes = {
            PickupVariant.PICKUP_COLLECTIBLE,
            PickupVariant.PICKUP_TAROTCARD,
            PickupVariant.PICKUP_PILL,
            PickupVariant.PICKUP_CHEST,
        }
        local pickupType = pickupTypes[math.random(1, #pickupTypes)]

        local present = Isaac.Spawn(EntityType.ENTITY_PICKUP, pickupType, 0,
            dropPos, Vector(0, 0), npc)
        if present then
            present:ToPickup():SetColor(Color(1, 0.2, 0.2, 1, 0, 1, 0), 999, 0, false)

            -- Track this present
            table.insert(presentPedestals, {
                entity = present,
                pos = dropPos,
                spawnFrame = frame,
            })
        end

        -- Trap visual
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.DEVIL, 0,
            dropPos, Vector(0, 0), nil)
    end

    -- Check if player touched any present
    local player = Isaac.GetPlayer(0)
    if not player or not player:Exists() then return end

    for i = #presentPedestals, 1, -1 do
        local p = presentPedestals[i]
        if not p.entity or not p.entity:Exists() then
            table.remove(presentPedestals, i)
        else
            local dist = (player.Position - p.entity.Position):Length()
            if dist < 30 then
                -- Player touched the trap present!
                -- Remove the pedestal
                p.entity:Remove()

                -- Spawn hostile enemies
                local enemyTypes = {
                    {EntityType.ENTITY_ATTACK_FLY, 0},
                    {EntityType.ENTITY_SPIDER, 0},
                    {EntityType.ENTITY_GAPER, 0},
                    {EntityType.ENTITY_NULL, 0},
                }

                for _ = 1, math.random(2, 3) do
                    local spawn = enemyTypes[math.random(1, #enemyTypes)]
                    local spawnPos = p.pos + Vector(math.random(-30, 30), math.random(-30, 30))
                    local enemy = Isaac.Spawn(spawn[1], spawn[2], 0,
                        spawnPos, Vector(0, 0), nil)
                    if enemy then
                        -- Make them aggressive toward the player
                        enemy:AddEntityFlags(EntityFlag.FLAG_CHARM)
                        enemy.Velocity = (player.Position - enemy.Position):Normalized() * 4
                    end
                end

                -- Smoke effect
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SMOKE_CLOUD, 0,
                    p.pos, Vector(0, 0), nil)

                table.remove(presentPedestals, i)
            end
        end
    end

    -- Clean up old presents
    for i = #presentPedestals, 1, -1 do
        if frame - presentPedestals[i].spawnFrame > 900 then -- 30 second timeout
            if presentPedestals[i].entity and presentPedestals[i].entity:Exists() then
                presentPedestals[i].entity:Remove()
            end
            table.remove(presentPedestals, i)
        end
    end
end

function mod:OnEntitySpawn(entity)
    -- Clean up pedestal tracking when entities get removed externally
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.OnEntitySpawn)
Isaac.DebugString("KrampusPresent loaded!")
