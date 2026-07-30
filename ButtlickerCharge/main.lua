-- ==========================================================================
--  ButtlickerCharge - The Binding of Isaac: Repentance
--  Buttlicker charges player leaving brown creep along path
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ButtlickerCharge", 1)
local game = Game()
local BUTTLICKER_TYPE = EntityType.ENTITY_BUTTLICKER

function mod:chargeUpdate(_, npc)
    if npc.Type ~= BUTTLICKER_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 100 == 0 and npc.Position:Distance(player.Position) < 300 then
        npc.Velocity = (player.Position - npc.Position):Normalized() * 6
        npc:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
    end
    if npc.Velocity:Length() > 2 then
        Isaac.GridSpawn(GridEntityType.GRID_POOP, 1, npc.Position, true)
    end
    if npc.FrameCount % 100 == 60 then
        npc:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
        npc.Velocity = Vector.Zero
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.chargeUpdate, BUTTLICKER_TYPE)
Isaac.DebugString("ButtlickerCharge loaded!")
