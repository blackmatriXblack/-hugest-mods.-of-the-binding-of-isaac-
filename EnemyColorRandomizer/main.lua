local mod = RegisterMod("EnemyColorRandomizer", 1)
local rng = RNG()

function mod:onEntitySpawn(entity)
    if entity:IsEnemy() then
        rng:SetSeed(entity.InitSeed, 2)
        local c = Color(rng:RandomFloat(), rng:RandomFloat(), rng:RandomFloat(), 1, 0, 0, 0)
        entity:SetColor(c, 99999, 0, true, false)
    end
end

mod:AddCallback(13, mod.onEntitySpawn) -- MC_POST_ENTITY_SPAWN
Isaac.DebugString("EnemyColorRandomizer: Random color tint applied to all enemies!")
