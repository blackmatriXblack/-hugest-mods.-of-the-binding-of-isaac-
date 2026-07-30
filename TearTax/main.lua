-- ==========================================================================
--  Tear Tax - The Binding of Isaac: Repentance
--  Each tear fired costs 1 coin — if coins reach 0 cannot fire
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TearTax", 1)
local game = Game()

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    local player = game:GetPlayer(0)
    if not player then return end

    if player:GetNumCoins() <= 0 then
        tear:Remove()
        Isaac.DebugString("No coins — cannot fire tears!")
    else
        player:AddCoins(-1)
        -- Tiny coin particle effect
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.COIN_PARTICLE,
            0, player.Position, Vector(math.random(-2, 2), -3), nil)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    local player = game:GetPlayer(0)
    if player then
        local coins = player:GetNumCoins()
        if coins <= 5 then
            Isaac.RenderText(string.format("COINS: %d (LOW!)", coins),
                55, 100, 0.8, 1, 0.3, 0.3)
        end
    end
end)

Isaac.DebugString("Tear Tax loaded!")
