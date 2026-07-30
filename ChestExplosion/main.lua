-- ChestExplosion: 20% chance to spawn a golden chest on enemy kill
local mod = RegisterMod("ChestExplosion", 1)

function mod:onEntityKill(entity)
    if entity:IsVulnerableEnemy() then
        local rng = RNG()
        rng:SetSeed(math.floor(os.time()), 0)
        if rng:RandomInt(100) < 20 then
            Isaac.Spawn(5, 360, 3, entity.Position, Vector(0, 0), nil)
            Isaac.DebugString("ChestExplosion: Golden chest spawned!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("ChestExplosion loaded! 20% golden chest on kills.")
