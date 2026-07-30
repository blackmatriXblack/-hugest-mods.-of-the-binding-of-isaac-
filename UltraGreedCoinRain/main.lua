-- =============================================================================
--  UltraGreedCoinRain - The Binding of Isaac: Repentance
--  Ultra Greed's coin attacks spawn 2 extra keepers
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("UltraGreedCoinRain", 1)
local ULTRA_GREED_ID = 406
local KEEPER_ID = EntityType.ENTITY_KEEPER
local lastSpawnFrame = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= ULTRA_GREED_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local room = Game():GetRoom()
    local player = Isaac.GetPlayer(0)

    -- Ultra Greed periodically "throws coins" (every 90 frames = 3 seconds)
    if frame - lastSpawnFrame < 90 then return end

    -- Check if Ultra Greed is in an attack state (has velocity indicating action)
    if npc.Velocity:Length() > 1 or math.random(1, 100) <= 30 then
        lastSpawnFrame = frame

        -- Spawn 2 extra Keepers that chase the player
        for _ = 1, 2 do
            local spawnPos = npc.Position + Vector(math.random(-60, 60), math.random(-60, 60))
            spawnPos = room:FindFreePickupSpawnPosition(spawnPos, 0, true)

            local keeper = Isaac.Spawn(KEEPER_ID, 0, 0, spawnPos, Vector(0, 0), npc)
            if keeper then
                -- Make keepers smaller but aggressive
                keeper.Scale = 0.8
                -- Coin visual
                local coin = Isaac.Spawn(EntityType.ENTITY_EFFECT,
                    EffectVariant.COIN_PARTICLE, 0,
                    spawnPos, Vector(0, -2), nil)
            end
        end

        -- Coin rain visual
        for _ = 1, 5 do
            local fallPos = room:GetCenterPos() +
                Vector(math.random(-200, 200), math.random(-150, 150))
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.COIN_PARTICLE, 0,
                fallPos, Vector(0, 3), nil)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("UltraGreedCoinRain loaded!")
