-- =============================================================================
--  PlayerDeathRevenge — The Binding of Isaac: Repentance
--  On death, explode dealing 200 damage to all enemies in room. Spawn Mega troll bomb.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PlayerDeathRevenge", 1)

function mod:onPlayerDeath(player)
    local pos = player.Position
    -- Deal 200 damage to all enemies in the room
    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
        local ent = entities[i]
        if ent:IsVulnerableEnemy() then
            ent:TakeDamage(200, DamageFlag.DAMAGE_EXPLOSION, EntityRef(player), 0)
        end
    end
    -- Spawn a Mega Troll Bomb at death location
    Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_MEGA_TROLL, 0, pos, Vector.Zero, player)
    -- Visual explosion effect
    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HUGE_EXPLOSION, 0, pos, Vector.Zero, nil)
    Isaac.DebugString("PlayerDeathRevenge: Revenge explosion triggered!")
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DEATH, mod.onPlayerDeath)
Isaac.DebugString("PlayerDeathRevenge loaded!")
