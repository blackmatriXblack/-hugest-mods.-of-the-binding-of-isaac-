-- ==========================================================================
--  Tears Only Challenge - The Binding of Isaac: Repentance
--  Player can ONLY use tears — no bombs, no active items, no cards, no pills
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TearsOnlyChallenge", 1)
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    for p = 0, game:GetNumPlayers() - 1 do
        local player = game:GetPlayer(p)
        if not player then break end

        -- Disable active item usage
        if player:GetActiveItem() ~= CollectibleType.COLLECTIBLE_NULL then
            player:RemoveCollectible(player:GetActiveItem())
        end

        -- Clear all bombs
        player:AddBombs(-player:GetNumBombs())

        -- Remove any cards/pills held
        if player:GetCard(0) ~= 0 then player:SetCard(0, 0) end
        if player:GetPill(0) ~= 0 then player:SetPill(0, 0) end

        -- Disable pocket items
        local pocket = player:GetActiveItem(0)
        if pocket ~= CollectibleType.COLLECTIBLE_NULL then
            player:RemoveCollectible(pocket)
        end
    end
end)

Isaac.DebugString("Tears Only Challenge loaded!")
