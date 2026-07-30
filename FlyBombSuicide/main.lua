-- ==========================================================================
--  FlyBombSuicide - The Binding of Isaac: Repentance
--  Fly Bomb homes on player and explodes with 3x normal bomb radius
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FlyBombSuicide", 1)
local game = Game()
local FLY_BOMB_TYPE = EntityType.ENTITY_FLY_BOMB

function mod:suicideUpdate(_, npc)
    if npc.Type ~= FLY_BOMB_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    local dist = npc.Position:Distance(player.Position)
    if dist < 200 then
        npc.Velocity = (player.Position - npc.Position):Normalized() * 4
    end
    if dist < 30 then
        Isaac.Explode(npc.Position, npc, 120)
        npc:Kill()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.suicideUpdate, FLY_BOMB_TYPE)
Isaac.DebugString("FlyBombSuicide loaded!")
