-- ==========================================================================
--  OobLevel2Ricochet - The Binding of Isaac: Repentance
--  Level 2 Oob ricochets 3 times off walls gaining speed each bounce.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("OobLevel2Ricochet", 1)
local ENEMY_OOB = 257
local RICOCHET_COOLDOWN = 180
local BOUNCE_SPEED_INCREASE = 1.3

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_OOB or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.ricochetTimer then data.ricochetTimer = 0 end
    if not data.bounceCount then data.bounceCount = 0 end
    if not data.baseSpeed then data.baseSpeed = npc.Velocity:Length() end

    if data.bounceCount > 0 then
        local vel = npc.Velocity
        local pos = npc.Position
        local room = Game():GetRoom()
        local bounced = false
        if pos.X <= room:GetTopLeftPos().X + 20 or pos.X >= room:GetBottomRightPos().X - 20 then
            npc.Velocity = Vector(-vel.X, vel.Y) * BOUNCE_SPEED_INCREASE
            bounced = true
        end
        if pos.Y <= room:GetTopLeftPos().Y + 20 or pos.Y >= room:GetBottomRightPos().Y - 20 then
            npc.Velocity = Vector(vel.X, -vel.Y) * BOUNCE_SPEED_INCREASE
            bounced = true
        end
        if bounced then
            data.bounceCount = data.bounceCount - 1
        end
        if data.bounceCount <= 0 then
            npc.Velocity = Vector.Zero
            data.ricochetTimer = 0
        end
    else
        data.ricochetTimer = data.ricochetTimer + 1
        if data.ricochetTimer >= RICOCHET_COOLDOWN then
            local player = Isaac.GetPlayer(0)
            if player then
                local dir = (player.Position - npc.Position):Normalized()
                npc.Velocity = dir * 5
                data.bounceCount = 3
                data.baseSpeed = 5
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("OobLevel2Ricochet loaded!")