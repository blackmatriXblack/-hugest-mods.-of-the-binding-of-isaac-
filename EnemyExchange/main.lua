-- ==========================================================================
--  Enemy Exchange - The Binding of Isaac: Repentance
--  Killing one enemy type spawns a different enemy type in its place
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("EnemyExchange", 1)
local game = Game()

local replacementPool = {
    EntityType.ENTITY_FLY, EntityType.ENTITY_POOTER, EntityType.ENTITY_GAPER,
    EntityType.ENTITY_HORF, EntityType.ENTITY_CLOTTY, EntityType.ENTITY_MULLIGAN,
    EntityType.ENTITY_MULLIBOOM, EntityType.ENTITY_HOPPER, EntityType.ENTITY_LEAPER,
    EntityType.ENTITY_SPIDER, EntityType.ENTITY_BIG_SPIDER, EntityType.ENTITY_LUMP,
    EntityType.ENTITY_VIS, EntityType.ENTITY_GLOOBIN, EntityType.ENTITY_GURGLING,
    EntityType.ENTITY_KNIGHT, EntityType.ENTITY_SELF_DEPRECIATING_KNIGHT,
    EntityType.ENTITY_HOST, EntityType.ENTITY_RED_HOST,
}

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(npc)
    if not npc:IsEnemy() then return end
    if npc:IsBoss() then return end  -- Don't exchange bosses

    local deadType = npc.Type

    -- Pick a random different enemy type
    local newType = replacementPool[math.random(1, #replacementPool)]
    while newType == deadType do
        newType = replacementPool[math.random(1, #replacementPool)]
    end

    -- Spawn replacement enemy where the old one died
    local replacement = Isaac.Spawn(newType, 0, 0,
        npc.Position, Vector(math.random(-2, 2), math.random(-2, 2)), nil)

    if replacement then
        -- Apply slight HP variation for variety
        replacement.HitPoints = replacement.MaxHitPoints * (0.8 + math.random() * 0.4)
        
        -- Small chance for champion variant
        if math.random() < 0.15 then
            replacement:MakeChampion(math.random(0, 9), EntityType.ENTITY_EFFECT, 0, true)
        end
    end
end)

Isaac.DebugString("Enemy Exchange loaded!")
