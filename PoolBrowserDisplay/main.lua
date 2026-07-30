-- List first 10 items in the treasure pool (pool 1) on new room
local mod = RegisterMod("PoolBrowserDisplay", 1)
local game = Game()

function mod:onNewRoom()
    local itemPool = game:GetItemPool()
    if itemPool then
        Isaac.DebugString("=== Treasure Pool Contents ===")
        for idx = 0, 9 do
            local itemId = itemPool:GetPoolItemId(1, idx)
            if itemId and itemId > 0 then
                local itemConfig = Isaac.GetItemConfig()
                if itemConfig then
                    local collectible = itemConfig:GetCollectible(itemId)
                    if collectible then
                        Isaac.DebugString("Pool[" .. idx .. "]: " .. itemId .. " - " .. collectible.Name)
                    else
                        Isaac.DebugString("Pool[" .. idx .. "]: " .. itemId)
                    end
                else
                    Isaac.DebugString("Pool[" .. idx .. "]: " .. itemId)
                end
            end
        end
        Isaac.DebugString("=== End Pool Contents ===")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
Isaac.DebugString("PoolBrowserDisplay loaded! Lists first 10 items in treasure pool each new room.")
