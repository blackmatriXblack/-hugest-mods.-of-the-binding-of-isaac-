-- =============================================================================
--  BlueBabyFlySpawn - The Binding of Isaac: Repentance
--  ??? (Blue Baby) periodically spawns blue attack flies that home on player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BlueBabyFlySpawn", 1)
local BLUE_BABY_ID = 274
local lastFlySpawn = 0
local totalFliesSpawned = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= BLUE_BABY_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local player = Isaac.GetPlayer(0)
    if not player or not player:Exists() then return end

    -- Spawn flies every 120 frames (4 seconds)
    -- Speed increases as boss HP decreases
    local hpPercent = npc.HitPoints / npc.MaxHitPoints
    local spawnInterval = 120 - (40 * (1 - hpPercent)) -- 120 to 80 frames

    if frame - lastFlySpawn < spawnInterval then return end
    lastFlySpawn = frame
    totalFliesSpawned = totalFliesSpawned + 1

    -- Spawn 3-5 blue attack flies
    local count = math.random(3, 5)
    for i = 1, count do
        local angle = (i * 360 / count) * math.pi / 180
        local offset = Vector(math.cos(angle), math.sin(angle)) * 60
        local spawnPos = npc.Position + offset

        local fly = Isaac.Spawn(EntityType.ENTITY_ATTACK_FLY, 0, 0,
            spawnPos, Vector(0, 0), npc)
        if fly then
            -- Tint blue
            fly:SetColor(Color(0.3, 0.5, 1, 1, 0, 0, 0), 999, 0, false, false)
            fly.Scale = 1.1

            -- Initial burst toward player
            fly.Velocity = (player.Position - fly.Position):Normalized() * 5

            -- Every 4th fly is a tougher Eternal Fly
            if i % 4 == 0 then
                fly:AddEntityFlags(EntityFlag.FLAG_ETERNAL)
                fly:SetColor(Color(0.2, 0.7, 1, 1, 0, 0, 0), 999, 0, false, false)
                fly.Scale = 1.3
            end
        end
    end

    -- Death burst effect when HP below 25%: more flies
    if hpPercent < 0.25 and math.random(1, 100) <= 40 then
        local burstFly = Isaac.Spawn(EntityType.ENTITY_ATTACK_FLY, 0, 0,
            npc.Position + Vector(0, -40), Vector(0, -3), npc)
        if burstFly then
            burstFly:AddEntityFlags(EntityFlag.FLAG_CHARM)
        end
    end

    -- Blue particle effect
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BATTERY, 0,
        npc.Position, Vector(0, -1), nil)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("BlueBabyFlySpawn loaded!")
