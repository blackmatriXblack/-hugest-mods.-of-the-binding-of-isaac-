-- ==========================================================================
--  Pacifist Reward - The Binding of Isaac: Repentance
--  Killing zero enemies in a room gives double room clear rewards
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("PacifistReward", 1)
local game = Game()
local enemiesKilledThisRoom = 0
local wasPacifist = false

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    enemiesKilledThisRoom = 0
    wasPacifist = false
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(npc)
    if npc:IsEnemy() then
        enemiesKilledThisRoom = enemiesKilledThisRoom + 1
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_TRIGGER_CLEAR, function()
    if enemiesKilledThisRoom == 0 then
        wasPacifist = true
        
        local player = game:GetPlayer(0)
        if player then
            local room = game:GetRoom()
            
            -- Double rewards: spawn extra consumables as reward
            local rewards = {
                {PickupVariant.PICKUP_COIN, 5},
                {PickupVariant.PICKUP_HEART, PickupSubType.HEART_FULL},
                {PickupVariant.PICKUP_BOMB, 5},
                {PickupVariant.PICKUP_KEY, 5},
            }

            for _, reward in ipairs(rewards) do
                local rewardPos = room:FindFreePickupSpawnPosition(player.Position, 1, true)
                local pickup = Isaac.Spawn(EntityType.ENTITY_PICKUP, reward[1], reward[2],
                    rewardPos, Vector(math.random(-3, 3), math.random(-3, 3)), nil)
            end

            -- Special bonus: chance for a pedestal item on pacifist clear
            if math.random() < 0.15 then
                local itemPool = game:GetItemPool()
                local item = itemPool:GetCollectible(ItemPoolType.POOL_TREASURE, true)
                local itemPos = room:FindFreePickupSpawnPosition(player.Position, 1, true)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE,
                    item, itemPos, Vector.Zero, nil)
            end

            -- Visual feedback
            Isaac.DebugString("PACIFIST BONUS! Double rewards awarded.")
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if enemiesKilledThisRoom == 0 then
        Isaac.RenderText("PACIFIST RUN", 270, 30, 0.7, 0.3, 1, 0.3)
    end
end)

Isaac.DebugString("Pacifist Reward loaded!")
