-- ==========================================================================
--  RedGhostPossess - The Binding of Isaac: Repentance
--  Red Ghost possesses player briefly, reversing movement controls for 2 seconds.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RedGhostPossess", 1)
local ENEMY_RED_GHOST = 285
local POSSESS_COOLDOWN = 300
local POSSESS_DURATION = 60
local POSSESS_RANGE = 80

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_RED_GHOST then return end
    local data = npc:GetData()
    if not data.possessTimer then data.possessTimer = 0 end
    if not data.isPossessing then data.isPossessing = false end
    if not data.possessDuration then data.possessDuration = 0 end

    if data.isPossessing then
        data.possessDuration = data.possessDuration + 1
        local player = Isaac.GetPlayer(0)
        if player then
            -- Reverse movement controls
            local input = player:GetMovementInput()
            player.Velocity = -input
        end
        if data.possessDuration >= POSSESS_DURATION then
            data.isPossessing = false
            data.possessTimer = 0
            if player then
                player.ControlsEnabled = true
            end
        end
    else
        data.possessTimer = data.possessTimer + 1
        if data.possessTimer >= POSSESS_COOLDOWN then
            local player = Isaac.GetPlayer(0)
            if player then
                local dist = player.Position:Distance(npc.Position)
                if dist < POSSESS_RANGE then
                    data.isPossessing = true
                    data.possessDuration = 0
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("RedGhostPossess loaded!")