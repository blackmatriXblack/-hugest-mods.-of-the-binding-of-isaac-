-- ==========================================================================
--  FistuloidSegment - The Binding of Isaac: Repentance
--  Fistuloid segments reform if not all killed within 3 seconds
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FistuloidSegment", 1)
local game = Game()
local FISTULOID_TYPE = EntityType.ENTITY_FISTULOID
local segmentDeathTimes = {}

function mod:segmentDeath(_, npc)
    if npc.Type ~= FISTULOID_TYPE then return end
    local time = game:GetFrameCount()
    table.insert(segmentDeathTimes, {time = time, pos = npc.Position, parent = npc.Parent})
    -- After all segments checked, if 3s passed and not all dead, reform
    local allDead = true
    local ents = Isaac.GetRoomEntities()
    local fistuloidAlive = false
    for _, ent in ipairs(ents) do
        if ent.Type == FISTULOID_TYPE and ent:IsDead() == false then
            allDead = false
            fistuloidAlive = true
        end
    end
    if not allDead and #segmentDeathTimes > 0 then
        for i = #segmentDeathTimes, 1, -1 do
            if game:GetFrameCount() - segmentDeathTimes[i].time > 90 then
                Isaac.Spawn(FISTULOID_TYPE, 0, 0, segmentDeathTimes[i].pos, Vector.Zero, nil)
                table.remove(segmentDeathTimes, i)
            end
        end
    end
    if not fistuloidAlive then
        segmentDeathTimes = {}
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.segmentDeath, FISTULOID_TYPE)
Isaac.DebugString("FistuloidSegment loaded!")
