local mod = RegisterMod("EnemyScaleRandomizer", 1)
local rng = RNG()

function mod:onEntitySpawn(entity)
    if entity:IsEnemy() then
        rng:SetSeed(entity.InitSeed, 1)
        entity.Scale = 0.5 + rng:RandomFloat() * 1.5
    end
end

mod:AddCallback(13, mod.onEntitySpawn) -- MC_POST_ENTITY_SPAWN
Isaac.DebugString("EnemyScaleRandomizer: Random enemy scale between 0.5 and 2.0!")
