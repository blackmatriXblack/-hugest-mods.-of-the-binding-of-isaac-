-- ==========================================================================
--  DumpRoll - The Binding of Isaac: Repentance
--  Dump enemy rolls toward player leaving poop creep trail behind
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DumpRoll", 1)
local game = Game()
local DUMP_TYPE = EntityType.ENTITY_DUMP

function mod:rollUpdate(_, npc)
    if npc.Type ~= DUMP_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 120 == 0 and npc.Position:Distance(player.Position) < 350 then
        npc.Velocity = (player.Position - npc.Position):Normalized() * 5
    end
    if npc.Velocity:Length() > 2 then
        Isaac.GridSpawn(GridEntityType.GRID_POOP, 0, npc.Position, true)
    end
    npc.Velocity = npc.Velocity * 0.98
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.rollUpdate, DUMP_TYPE)
Isaac.DebugString("DumpRoll loaded!")
