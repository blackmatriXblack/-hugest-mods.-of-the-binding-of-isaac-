-- ==========================================================================
--  DepthWormBurrow - The Binding of Isaac: Repentance
--  Depth Worm burrows and pops up 3 times in random locations before attacking
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DepthWormBurrow", 1)
local game = Game()
local WORM_TYPE = EntityType.ENTITY_ROUND_WORM
local DEPTH_VARIANT = 3
local wormPhase = {}

function mod:burrowUpdate(_, npc)
    if npc.Type ~= WORM_TYPE or npc.Variant ~= DEPTH_VARIANT then return end
    local idx = GetPtrHash(npc)
    if wormPhase[idx] == nil then wormPhase[idx] = {phase = 0, timer = 0, pops = 0} end
    local data = wormPhase[idx]
    local player = game:GetPlayer(0)
    if not player then return end
    data.timer = data.timer + 1
    if data.timer > 40 then
        data.timer = 0
        if data.pops < 3 then
            local room = game:GetRoom()
            local rx = room:GetGridWidth() * 40
            local ry = room:GetGridHeight() * 40
            local randomPos = room:GetRandomPosition(10)
            npc.Position = randomPos
            npc.Velocity = (player.Position - randomPos):Resized(3)
            data.pops = data.pops + 1
        else
            npc.Velocity = (player.Position - npc.Position):Resized(8)
            data.pops = 0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.burrowUpdate, WORM_TYPE)
Isaac.DebugString("DepthWormBurrow loaded!")
