-- =============================================================================
--  MomsFootStomp — The Binding of Isaac: Repentance
--  Mom (Type=31) stomp creates shockwave that deals damage in larger radius
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MomsFootStomp", 1)

local MOM_TYPE = EntityType.ENTITY_MOM
local MOM_VARIANT = 0
local SHOCKWAVE_DAMAGE = 1.0 -- Half heart
local SHOCKWAVE_RADIUS = 120
local STOMP_STATE = 4 -- Mom's stomp state

local wasStomping = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= MOM_TYPE or npc.Variant ~= MOM_VARIANT then
        return
    end

    local idx = GetPtrHash(npc)
    local isStomping = npc.State == STOMP_STATE
    local prevStomping = wasStomping[idx] or false

    -- Detect stomp just happened (transition into stomp state)
    if isStomping and not prevStomping then
        -- Create shockwave effect at Mom's foot position
        for i = 0, Game():GetNumPlayers() - 1 do
            local player = Isaac.GetPlayer(i)
            if player and player:IsAlive() then
                local footDist = npc.Position:Distance(player.Position)
                if footDist <= SHOCKWAVE_RADIUS then
                    player:TakeDamage(SHOCKWAVE_DAMAGE, DamageFlag.DAMAGE_NOKILL, EntityRef(npc), 0)
                end
            end
        end

        -- Visual shockwave expanding circle
        local shockwave = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0,
            npc.Position, Vector.Zero, npc)
    end

    wasStomping[idx] = isStomping
end

function mod:onNPCDeath(npc)
    local idx = GetPtrHash(npc)
    wasStomping[idx] = nil
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNPCDeath)
Isaac.DebugString("MomsFootStomp loaded!")
