-- =============================================================================
--  PlayerUpdateAura — The Binding of Isaac: Repentance
--  Player has a damaging aura: enemies within 60 range take 0.5 damage per tick.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PlayerUpdateAura", 1)
local damageCooldown = 0

function mod:onPlayerUpdate(player)
    damageCooldown = damageCooldown - 1
    if damageCooldown > 0 then return end
    damageCooldown = 15 -- ticks between damage application

    local entities = Isaac.GetRoomEntities()
    for i = 1, #entities do
        local ent = entities[i]
        if ent:IsVulnerableEnemy() then
            if ent.Position:Distance(player.Position) <= 60 then
                ent:TakeDamage(0.5, DamageFlag.DAMAGE_NO_PENALTIES, EntityRef(player), 0)
                -- Visual feedback: brief red flash
                local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ITEM_FLYING_COSTUME, 0, ent.Position, Vector.Zero, nil)
                if effect then
                    effect:GetSprite():SetColor(Color(1, 0.3, 0.3, 1, 0, 0, 0))
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("PlayerUpdateAura loaded!")
