-- =============================================================================
--  GaperJumpScare — The Binding of Isaac: Repentance
--  Gapers (Type=4) teleport behind player when far away.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GaperJumpScare", 1)

local TELEPORT_DISTANCE = 200
local TELEPORT_OFFSET = 60
local TELEPORT_COOLDOWN = 120  -- 4 seconds
local cooldowns = {}

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= 4 then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local dist = npc.Position:Distance(player.Position)
    if dist < TELEPORT_DISTANCE then return end

    local idx = npc.Index
    cooldowns[idx] = cooldowns[idx] or 0

    if cooldowns[idx] > 0 then
        cooldowns[idx] = cooldowns[idx] - 1
        return
    end

    -- Teleport behind the player
    local playerDir = player.Velocity:Length() > 0.1
        and player.Velocity:Normalized()
        or Vector(0, 1)  -- Default: behind (below) player

    local behindPos = player.Position - playerDir * TELEPORT_OFFSET
    npc.Position = behindPos
    cooldowns[idx] = TELEPORT_COOLDOWN
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("GaperJumpScare loaded!")
