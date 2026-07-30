-- =============================================================================
--  KeeperCoinUp - The Binding of Isaac: Repentance
--  Keeper generates 1 extra coin on every room clear.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("KeeperCoinUp", 1)
local prevRoomIndex = -1

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, function(_, player)
    if player:GetPlayerType() ~= PlayerType.PLAYER_KEEPER then
        return
    end
    local room = Game():GetRoom()
    local curRoomIndex = room:GetDecorationSeed()
    -- When room changes and was cleared, give coin
    if curRoomIndex ~= prevRoomIndex and room:IsClear() then
        prevRoomIndex = curRoomIndex
        player:AddCoins(1)
    end
end)

Isaac.DebugString("KeeperCoinUp loaded!")
