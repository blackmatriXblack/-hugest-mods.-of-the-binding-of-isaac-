-- =============================================================================
--  TaintedKeeperShopRestock - The Binding of Isaac: Repentance
--  Tainted Keeper gets an extra shop item restock per floor.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedKeeperShopRestock", 1)

mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function()
    for i = 0, Game():GetNumPlayers() - 1 do
        local player = Game():GetPlayer(i)
        if player:GetPlayerType() == PlayerType.PLAYER_TAINTEDKEEPER then
            -- Trigger one extra shop restock on new floor
            local room = Game():GetRoom()
            if room:GetType() == RoomType.ROOM_SHOP then
                room:Restock()
            end
        end
    end
end)

Isaac.DebugString("TaintedKeeperShopRestock loaded!")
