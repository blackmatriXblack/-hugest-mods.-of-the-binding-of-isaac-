-- =============================================================================
--  DeathsHeadChase - The Binding of Isaac: Repentance
--  Death's Head constantly accelerates toward player instead of moving linearly
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DeathsHeadChase", 1)
local DEATHS_HEAD_TYPE = 212
local ACCEL_FACTOR = 0.08
local MAX_SPEED = 6.0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= DEATHS_HEAD_TYPE then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local data = npc:GetData()
    data.velX = data.velX or npc.Velocity.X
    data.velY = data.velY or npc.Velocity.Y

    -- Accelerate toward player
    local toPlayer = (player.Position - npc.Position):Normalized()
    data.velX = data.velX + toPlayer.X * ACCEL_FACTOR
    data.velY = data.velY + toPlayer.Y * ACCEL_FACTOR

    -- Clamp max speed
    local speed = math.sqrt(data.velX * data.velX + data.velY * data.velY)
    if speed > MAX_SPEED then
        data.velX = data.velX / speed * MAX_SPEED
        data.velY = data.velY / speed * MAX_SPEED
    end

    npc.Velocity = Vector(data.velX, data.velY)

    -- Look toward player
    npc:Pathfind(player.Position, 0.3, 0)
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("DeathsHeadChase loaded!")
