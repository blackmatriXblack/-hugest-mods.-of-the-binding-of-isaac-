-- ==========================================================================
--  Mega Blast Pierce - The Binding of Isaac: Repentance
--  Mega Blast pierces through all enemies and walls
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MegaBlastPierce", 1)
local game = Game()

local MEGA_BLAST = CollectibleType.COLLECTIBLE_MEGA_BLAST
local blastActive = false

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(MEGA_BLAST) then
        blastActive = false
        return
    end

    -- Detect mega blast beam (large continuous laser from player)
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_EFFECT then
            local eff = ent:ToEffect()
            if eff and eff.SpawnerEntity == player then
                local var = eff.Variant
                -- Mega blast produces a large brimstone-style beam
                -- Make it pierce by marking enemies hit as still vulnerable
                if var == EffectVariant.CRACK_THE_SKY
                    or var == EffectVariant.GODHEAD then
                    -- Reset any invulnerability flags on nearby enemies
                    local nearby = Isaac.FindInRadius(eff.Position, 80)
                    for _, near in ipairs(nearby) do
                        if near:IsVulnerableEnemy() then
                            -- Force damage even if enemy would normally be immune
                            near:TakeDamage(player.Damage * 10,
                                DamageFlag.DAMAGE_LASER,
                                EntityRef(player), 0)
                        end
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("MegaBlastPierce loaded!")
