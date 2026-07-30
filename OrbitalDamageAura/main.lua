-- =============================================================================
--  OrbitalDamageAura - The Binding of Isaac: Repentance
--  All orbitals deal damage over time to nearby enemies (not just contact).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("OrbitalDamageAura", 1)

local AURA_RANGE = 60
local DAMAGE_PER_TICK = 0.4

function mod:onNpcUpdate()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent:IsVulnerableEnemy() then
            for _, orbitEnt in ipairs(entities) do
                if orbitEnt.Type == EntityType.ENTITY_EFFECT then
                    -- Check for orbital-type familiars around player
                    local dist = (ent.Position - orbitEnt.Position):Length()
                    if dist < AURA_RANGE then
                        ent:TakeDamage(DAMAGE_PER_TICK, DamageFlag.DAMAGE_NOKILL, EntityRef(player), 0)
                        ent:SetColor(Color(0.8, 0.3, 1.0, 1.0, 0, 0, 0), 3, 0)
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("OrbitalDamageAura loaded!")
