-- ==========================================================================
--  SpiderLevel2Jump - The Binding of Isaac: Repentance
--  Level 2 Spider jumps toward player from any position in room.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SpiderLevel2Jump", 1)
local ENEMY_SPIDER = 85
local JUMP_INTERVAL = 90
local JUMP_SPEED = 14

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_SPIDER or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.jumpTimer then data.jumpTimer = 0 end
    if not data.isJumping then data.isJumping = false end

    if data.isJumping then
        if npc.Velocity:Length() < 1 then
            data.isJumping = false
            data.jumpTimer = 0
        end
    else
        data.jumpTimer = data.jumpTimer + 1
        if data.jumpTimer >= JUMP_INTERVAL then
            local player = Isaac.GetPlayer(0)
            if player then
                npc.Velocity = (player.Position - npc.Position):Normalized() * JUMP_SPEED
                data.isJumping = true
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("SpiderLevel2Jump loaded!")