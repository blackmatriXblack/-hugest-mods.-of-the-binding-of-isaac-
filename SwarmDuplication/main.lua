-- ==========================================================================
--  SwarmDuplication - The Binding of Isaac: Repentance
--  Swarm enemy duplicates itself once every 15 seconds (max 4 copies).
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SwarmDuplication", 1)
local ENEMY_SWARM = 84
local DUPLICATE_INTERVAL = 450
local MAX_COPIES = 4

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_SWARM then return end
    local data = npc:GetData()
    if not data.dupeTimer then data.dupeTimer = 0 end
    if not data.isCopy then data.isCopy = false end

    data.dupeTimer = data.dupeTimer + 1
    if data.dupeTimer >= DUPLICATE_INTERVAL and not data.isCopy then
        -- Count existing copies in room
        local room = Game():GetRoom()
        local copyCount = 0
        for i = 0, room:GetAliveEnemiesCount() - 1 do
            local other = room:GetAliveEnemy(i)
            if other and other.Type == ENEMY_SWARM then
                local odata = other:GetData()
                if odata.isCopy then
                    copyCount = copyCount + 1
                end
            end
        end

        if copyCount < MAX_COPIES then
            local offset = Vector(math.random(-60, 60), math.random(-60, 60))
            local copy = Isaac.Spawn(ENEMY_SWARM, npc.Variant, npc.SubType, npc.Position + offset, Vector(math.random(-2, 2), math.random(-2, 2)), npc)
            if copy then
                local cdata = copy:GetData()
                cdata.isCopy = true
            end
        end
        data.dupeTimer = 0
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("SwarmDuplication loaded!")