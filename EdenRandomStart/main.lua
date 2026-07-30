-- =============================================================================
--  EdenRandomStart - The Binding of Isaac: Repentance
--  Eden starts with 2 random trinkets instead of 1.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("EdenRandomStart", 1)

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, function(_, player)
    if player:GetPlayerType() == PlayerType.PLAYER_EDEN then
        -- Add a second random trinket in addition to the default one
        local rng = RNG()
        rng:SetSeed(Random(), 0)
        local trinketList = {}
        for id = 1, 187 do
            if id ~= 127 then -- exclude some invalid trinkets
                table.insert(trinketList, id)
            end
        end
        local randomIndex = rng:RandomInt(#trinketList) + 1
        player:AddTrinket(trinketList[randomIndex])
    end
end)

Isaac.DebugString("EdenRandomStart loaded!")
