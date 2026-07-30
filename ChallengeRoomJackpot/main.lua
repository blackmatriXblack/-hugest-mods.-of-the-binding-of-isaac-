-- =============================================================================
--  ChallengeRoomJackpot — The Binding of Isaac: Repentance
--  Challenge rooms contain 3 items from boss pool on clear instead of normal reward.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ChallengeRoomJackpot", 1)

local REWARD_COUNT = 3

function mod:SpawnBossPoolRewards()
    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_CHALLENGE then
        local center = room:GetCenterPos()
        local itemPool = Game():GetItemPool()
        for i = 1, REWARD_COUNT do
            local itemId = itemPool:GetCollectible(ItemPoolType.POOL_BOSS, true, RNG())
            if itemId ~= CollectibleType.COLLECTIBLE_NULL then
                local offset = Vector((i - 2) * 30, 0)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, itemId,
                    center + offset, Vector.Zero, nil)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.SpawnBossPoolRewards)
Isaac.DebugString("ChallengeRoomJackpot loaded!")
