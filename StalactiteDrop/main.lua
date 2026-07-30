-- ==========================================================================
--  StalactiteDrop - The Binding of Isaac: Repentance
--  Stalactite ceiling enemy drops on player when they walk underneath
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("StalactiteDrop", 1)
local game = Game()
local STALACTITE_TYPE = EntityType.ENTITY_STALACTITE
local fallingList = {}

function mod:dropUpdate(_, npc)
    if npc.Type ~= STALACTITE_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    local idx = GetPtrHash(npc)
    if fallingList[idx] then
        local room = game:GetRoom()
        if npc.Position.Y > room:GetGridHeight() * 40 + 20 then
            npc:Kill()
            fallingList[idx] = nil
        end
        return
    end
    if math.abs(npc.Position.X - player.Position.X) < 30 and npc.Position.Y < player.Position.Y then
        npc.Velocity = Vector(0, 8)
        fallingList[idx] = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.dropUpdate, STALACTITE_TYPE)
Isaac.DebugString("StalactiteDrop loaded!")
