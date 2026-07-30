-- ==========================================================================
--  Boss Relay - The Binding of Isaac: Repentance
--  After beating a boss a harder boss immediately spawns in the same room
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BossRelay", 1)
local game = Game()
local bossSpawnedThisRoom = false

local function IsBoss(entity)
    return entity:IsBoss() or entity:IsChampion()
end

local harderBosses = {
    EntityType.ENTITY_MONSTRO, EntityType.ENTITY_MONSTRO_2,
    EntityType.ENTITY_LARRY_JR, EntityType.ENTITY_THE_HOLLOW,
    EntityType.ENTITY_DUKE_OF_FLIES, EntityType.ENTITY_THE_HUSK,
    EntityType.ENTITY_BLOAT, EntityType.ENTITY_THE_FALLEN,
    EntityType.ENTITY_PIN, EntityType.ENTITY_SCOLEX,
    EntityType.ENTITY_FAMINE, EntityType.ENTITY_DEATH,
    EntityType.ENTITY_WAR, EntityType.ENTITY_CONQUEST,
    EntityType.ENTITY_PESTILENCE, EntityType.ENTITY_DEATH,
}

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    bossSpawnedThisRoom = false
end)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(npc)
    if bossSpawnedThisRoom then return end
    if not IsBoss(npc) then return end

    bossSpawnedThisRoom = true

    -- Spawn a harder boss on a short delay
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02, 0,
        npc.Position, Vector.Zero, nil)

    -- Pick a random harder boss and spawn it
    local bossType = harderBosses[math.random(1, #harderBosses)]
    local variants = {0, 0, 0, 0, 1, 2, 5, 10}
    local variant = variants[math.random(1, #variants)]

    local newBoss = Isaac.Spawn(bossType, variant, 0,
        npc.Position, Vector.Zero, nil)
    if newBoss then
        newBoss.HitPoints = newBoss.MaxHitPoints * 1.5
        newBoss:MakeChampion(math.random(0, 9), EntityType.ENTITY_EFFECT, 0, true)
        Isaac.DebugString("Relay Boss has appeared!")
    end
end)

Isaac.DebugString("Boss Relay loaded!")
