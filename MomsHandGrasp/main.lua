-- ==========================================================================
--  MomsHandGrasp - The Binding of Isaac: Repentance
--  Mom's Hand grabs player from ceiling, holds for 2 seconds.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MomsHandGrasp", 1)
local ENEMY_MOMS_HAND = 213
local GRAB_COOLDOWN = 180
local HOLD_DURATION = 60

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_MOMS_HAND then return end
    local data = npc:GetData()
    if not data.grabTimer then data.grabTimer = 0 end
    if not data.holdState then data.holdState = 0 end
    if not data.holdTimer then data.holdTimer = 0 end

    if data.holdState == 1 then
        -- Holding player
        local player = Isaac.GetPlayer(0)
        if player then
            player.Velocity = Vector.Zero
            player.ControlsEnabled = false
        end
        data.holdTimer = data.holdTimer + 1
        if data.holdTimer >= HOLD_DURATION then
            data.holdState = 0
            if player then
                player.ControlsEnabled = true
                player:TakeDamage(1.0, DamageFlag.DAMAGE_NOKILL, EntityRef(npc), 0)
            end
            data.grabTimer = 0
        end
    else
        data.grabTimer = data.grabTimer + 1
        if data.grabTimer >= GRAB_COOLDOWN then
            local player = Isaac.GetPlayer(0)
            if player then
                local dist = player.Position:Distance(npc.Position)
                if dist < 100 then
                    data.holdState = 1
                    data.holdTimer = 0
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("MomsHandGrasp loaded!")