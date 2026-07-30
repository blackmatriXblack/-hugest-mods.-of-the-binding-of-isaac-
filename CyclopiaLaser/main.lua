-- =============================================================================
--  CyclopiaLaser - The Binding of Isaac: Repentance
--  Cyclopia alternates between brimstone laser and rapid homing shots
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CyclopiaLaser", 1)
local CYCLOPIA_TYPE = 282
local PHASE_DURATION = 90 -- frames per phase (3 seconds)
local LASER_CHARGE_TIME = 30
local HOMING_INTERVAL = 12

function mod:OnNPCUpdate(npc)
    if npc.Type ~= CYCLOPIA_TYPE then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local data = npc:GetData()
    data.phaseTimer = (data.phaseTimer or 0) + 1

    -- Switch phase every PHASE_DURATION frames
    if data.phaseTimer >= PHASE_DURATION * 2 then
        data.phaseTimer = 0
        data.phase = nil
    end

    -- Determine current phase (0 = laser, 1 = homing)
    local phase = data.phaseTimer >= PHASE_DURATION and 1 or 0

    if phase == 0 then
        -- BRIMSTONE PHASE
        data.chargeTimer = (data.chargeTimer or 0) + 1

        if data.chargeTimer == LASER_CHARGE_TIME then
            -- Fire brimstone laser toward player
            local dir = (player.Position - npc.Position):Normalized()
            local laser = Isaac.Spawn(EntityType.ENTITY_LASER, 2, 0, npc.Position, dir * 10, npc):ToLaser()
            if laser then
                laser.Timeout = 25
                laser.Radius = 12
                laser.MaxDistance = 300
                laser:SetActiveRotation(0, 100, 5)
            end
        elseif data.chargeTimer >= LASER_CHARGE_TIME + 60 then
            data.chargeTimer = 0
        end

        -- Charge visual: red glow
        if data.chargeTimer > 0 and data.chargeTimer < LASER_CHARGE_TIME then
            npc.Color = Color(1, 0.5 + math.sin(data.chargeTimer) * 0.5, 0.5, 1, 0, 0, 0)
        else
            npc.Color = Color(1, 1, 1, 1, 0, 0, 0)
        end

    else
        -- RAPID HOMING PHASE
        data.homingTimer = (data.homingTimer or 0) + 1
        npc.Color = Color(0.6, 1, 0.6, 1, 0, 0, 0) -- green tint

        if data.homingTimer >= HOMING_INTERVAL then
            data.homingTimer = 0
            local dir = (player.Position - npc.Position):Normalized()
            local spawnPos = npc.Position + dir * 25

            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, spawnPos, dir * 4, npc):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_HOMING)
                tear.Scale = 0.6
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("CyclopiaLaser loaded!")
