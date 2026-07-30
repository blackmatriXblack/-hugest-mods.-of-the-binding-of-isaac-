-- Enemy Loot Pinata — 5x drops from all enemies
local mod = RegisterMod("EnemyLootPinata", 1)
local rng = RNG(); rng:SetSeed(math.floor(os.time()), 0)
function mod:onEntityKill(entity)
    if entity == nil or not entity:IsEnemy() then return end
    local pos = entity.Position
    local player = Isaac.GetPlayer(0)
    -- 5x drop explosion: coins, hearts, bombs, keys
    for i = 1, 5 do
        local dropPos = Vector(pos.X + rng:RandomInt(60) - 30, pos.Y + rng:RandomInt(60) - 30)
        local roll = rng:RandomInt(4)
        if roll == 0 then Isaac.Spawn(5, 20, 1, dropPos, Vector(0, 0), nil)        -- coin
        elseif roll == 1 then Isaac.Spawn(5, 40, 1, dropPos, Vector(0, 0), nil)     -- bomb
        elseif roll == 2 then Isaac.Spawn(5, 30, 1, dropPos, Vector(0, 0), nil)     -- key
        else Isaac.Spawn(5, 10, 2, dropPos, Vector(0, 0), player) end               -- full heart
    end
end
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("Enemy Loot Pinata loaded! 5x enemy drops.")
