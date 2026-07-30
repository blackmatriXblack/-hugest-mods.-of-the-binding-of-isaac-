-- GreedModeGold: Enemies in Greed Mode drop double coins on kill
local mod = RegisterMod("GreedModeGold", 1)

function mod:onEntityKill(entity)
    local game = Game()
    if game:IsGreedMode() and entity:IsVulnerableEnemy() then
        local player = Isaac.GetPlayer(0)
        player:AddCoins(2)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("GreedModeGold loaded! Double coins from Greed Mode kills.")
