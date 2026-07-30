local mod = RegisterMod("EntityMakeChampion", 1)
local rng = RNG()

function mod:onEntitySpawn(entity)
    if entity:IsEnemy() then
        rng:SetSeed(entity.InitSeed, 0)
        if rng:RandomInt(10) == 0 then
            entity:MakeChampion(entity.InitSeed, 1, false)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_SPAWN, mod.onEntitySpawn)
