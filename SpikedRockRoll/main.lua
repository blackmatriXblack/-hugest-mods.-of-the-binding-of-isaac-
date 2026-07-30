-- ==========================================================================
--  SpikedRockRoll - The Binding of Isaac: Repentance
--  Spiked rock obstacle rolls toward player when they get close
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SpikedRockRoll", 1)
local game = Game()
local ROCK_TYPE = EntityType.ENTITY_ROCK

function mod:rollUpdate(_, npc)
    if npc.Type ~= ROCK_TYPE or npc.Variant ~= 2 then return end
    local player = game:GetPlayer(0)
    if not player then return end
    local dist = npc.Position:Distance(player.Position)
    if dist < 150 then
        npc.Velocity = (player.Position - npc.Position):Normalized() * 3
        npc.EntityCollisionClass = EntityCollisionClass.ENTCOLL_PLAYEROBJECTS
    else
        npc.Velocity = npc.Velocity * 0.95
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.rollUpdate, ROCK_TYPE)
Isaac.DebugString("SpikedRockRoll loaded!")
