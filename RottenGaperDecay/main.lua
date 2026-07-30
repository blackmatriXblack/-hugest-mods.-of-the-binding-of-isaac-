-- ==========================================================================
--  RottenGaperDecay - The Binding of Isaac: Repentance
--  Rotten Gaper leaves decay aura that damages player over time when near.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RottenGaperDecay", 1)
local ENEMY_ROTTEN_GAPER = 236
local DECAY_RADIUS = 80
local DECAY_TICK = 30

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_ROTTEN_GAPER then return end
    local data = npc:GetData()
    if not data.decayTick then data.decayTick = 0 end

    local player = Isaac.GetPlayer(0)
    if player then
        local dist = player.Position:Distance(npc.Position)
        if dist < DECAY_RADIUS then
            -- Spawn decay particle effect
            data.decayTick = data.decayTick + 1
            if data.decayTick >= DECAY_TICK then
                data.decayTick = 0
                player:TakeDamage(0.5, DamageFlag.DAMAGE_NOKILL, EntityRef(npc), 0)
                -- Visual feedback
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POISON_CLOUD, 0, player.Position, Vector.Zero, npc)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("RottenGaperDecay loaded!")