-- =============================================================================
--  Trapdoor Spawner - The Binding of Isaac: Repentance
--  Boss kill spawns both Devil Room trapdoor AND Angel Room beam!
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TrapdoorSpawner", 1)

function mod:onNpcDeath(npc)
    -- Check if the dead entity is a boss
    if not npc:IsBoss() then return end

    local pos = npc.Position
    local room = Game():GetRoom()

    -- Spawn Devil Room trapdoor (left side)
    local devilDoor = Isaac.Spawn(EntityType.ENTITY_EFFECT,
        EffectVariant.DEVIL, 0,
        Vector(pos.X - 40, pos.Y), Vector.Zero, nil)
    if devilDoor then
        devilDoor:GetSprite().Color = Color(1, 0.1, 0.1, 1, 0, 0, 0) -- Blood red
        Isaac.DebugString("Devil trapdoor spawned!")
    end

    -- Spawn Angel Room beam (right side)
    local angelBeam = Isaac.Spawn(EntityType.ENTITY_EFFECT,
        EffectVariant.ANGEL, 0,
        Vector(pos.X + 40, pos.Y), Vector.Zero, nil)
    if angelBeam then
        angelBeam:GetSprite().Color = Color(0.3, 0.6, 1, 1, 0, 0, 0) -- Holy blue
        Isaac.DebugString("Angel beam spawned!")
    end

    -- Spawn a golden chest as bonus
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_CHEST,
        ChestSubType.CHEST_GOLDEN, Vector(pos.X, pos.Y - 30), Vector(0, -3), nil)

    Isaac.DebugString("HEAVEN AND HELL! Both exits spawned!")
    Game():ShakeScreen(8)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNpcDeath)
Isaac.DebugString("TrapdoorSpawner loaded!")
