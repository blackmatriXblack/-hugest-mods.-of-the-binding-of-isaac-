-- ==========================================================================
--  MawLevel2Vacuum - The Binding of Isaac: Repentance
--  Level 2 Maw creates a vacuum pulling player toward it.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MawLevel2Vacuum", 1)
local ENEMY_MAW = 243
local VACUUM_RADIUS = 250
local PULL_STRENGTH = 0.15
local ACTIVE_DURATION = 120
local COOLDOWN = 60

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_MAW or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.vacuumTimer then data.vacuumTimer = 0 end
    if not data.isVacuuming then data.isVacuuming = false end
    if not data.cooldownTimer then data.cooldownTimer = 0 end

    if data.isVacuuming then
        local player = Isaac.GetPlayer(0)
        if player then
            local dist = player.Position:Distance(npc.Position)
            if dist < VACUUM_RADIUS and dist > 10 then
                local pullDir = (npc.Position - player.Position):Normalized()
                player.Velocity = player.Velocity + pullDir * PULL_STRENGTH
            end
        end
        data.vacuumTimer = data.vacuumTimer + 1
        if data.vacuumTimer >= ACTIVE_DURATION then
            data.isVacuuming = false
            data.cooldownTimer = 0
        end
    else
        data.cooldownTimer = data.cooldownTimer + 1
        if data.cooldownTimer >= COOLDOWN then
            data.isVacuuming = true
            data.vacuumTimer = 0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("MawLevel2Vacuum loaded!")