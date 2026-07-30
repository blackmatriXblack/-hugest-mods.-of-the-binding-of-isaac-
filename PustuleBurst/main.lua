-- ==========================================================================
--  PustuleBurst - The Binding of Isaac: Repentance
--  Pustule bursts into poison cloud on death, poisoning all nearby entities.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("PustuleBurst", 1)
local ENEMY_PUSTULE = 282
local POISON_RADIUS = 120
local POISON_DURATION = 150

local function onNPCDeath(_, npc)
    if npc.Type ~= ENEMY_PUSTULE then return end
    local pos = npc.Position

    -- Spawn poison cloud effect
    local cloud = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POISON_CLOUD, 0, pos, Vector.Zero, npc)
    if cloud and cloud.Exists() then
        cloud:ToEffect()
        cloud.Timeout = POISON_DURATION
    end

    -- Poison all nearby enemies and player
    local player = Isaac.GetPlayer(0)
    if player and player.Position:Distance(pos) < POISON_RADIUS then
        player:AddPoison(EntityRef(npc), 90, 2)
    end

    local room = Game():GetRoom()
    for i = 0, room:GetAliveEnemiesCount() - 1 do
        local enemy = room:GetAliveEnemy(i)
        if enemy and enemy.Index ~= npc.Index then
            local dist = enemy.Position:Distance(pos)
            if dist < POISON_RADIUS then
                enemy:AddPoison(EntityRef(npc), 90, 3)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, onNPCDeath)
Isaac.DebugString("PustuleBurst loaded!")