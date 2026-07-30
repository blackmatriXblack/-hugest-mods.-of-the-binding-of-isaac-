-- ==========================================================================
--  LilHornCharge - The Binding of Isaac: Repentance
--  Lil Horn charges at player leaving shadow creep trail.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("LilHornCharge", 1)
local ENEMY_LIL_HORN = 287
local CHARGE_INTERVAL = 120
local CREEP_INTERVAL = 3

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_LIL_HORN then return end
    local data = npc:GetData()
    if not data.chargeTimer then data.chargeTimer = 0 end
    if not data.isCharging then data.isCharging = false end

    if data.isCharging then
        local vel = npc.Velocity
        if vel:Length() > 1 then
            -- Leave creep trail
            data.creepTimer = (data.creepTimer or 0) + 1
            if data.creepTimer >= CREEP_INTERVAL then
                data.creepTimer = 0
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_BLACK, 0, npc.Position, Vector.Zero, npc)
            end
        else
            data.isCharging = false
            data.chargeTimer = 0
        end
    else
        data.chargeTimer = data.chargeTimer + 1
        if data.chargeTimer >= CHARGE_INTERVAL then
            local player = Isaac.GetPlayer(0)
            if player then
                npc.Velocity = (player.Position - npc.Position):Normalized() * 10
                data.isCharging = true
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("LilHornCharge loaded!")