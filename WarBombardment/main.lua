-- =============================================================================
--  WarBombardment — The Binding of Isaac: Repentance
--  War (Type=66) drops 5 troll bombs in random positions every 8 seconds
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("WarBombardment", 1)

local WAR_TYPE = EntityType.ENTITY_WAR
local BOMB_INTERVAL = 240 -- 8 seconds at 30 FPS
local BOMB_COUNT = 5

local bombTimer = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= WAR_TYPE then
        return
    end

    local idx = GetPtrHash(npc)
    if not bombTimer[idx] then
        bombTimer[idx] = 0
    end

    bombTimer[idx] = bombTimer[idx] + 1

    if bombTimer[idx] >= BOMB_INTERVAL then
        bombTimer[idx] = 0

        local room = Game():GetRoom()
        local roomPos = room:GetCenterPos()
        local roomSize = room:GetGridSize()

        for i = 1, BOMB_COUNT do
            local offsetX = math.random(-roomSize * 20, roomSize * 20)
            local offsetY = math.random(-roomSize * 20, roomSize * 20)
            local bombPos = Vector(roomPos.X + offsetX, roomPos.Y + offsetY)
            Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_TROLL, 0, bombPos, Vector.Zero, npc)
        end
    end
end

function mod:onNPCDeath(npc)
    local idx = GetPtrHash(npc)
    bombTimer[idx] = nil
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.onNPCDeath)
Isaac.DebugString("WarBombardment loaded!")
