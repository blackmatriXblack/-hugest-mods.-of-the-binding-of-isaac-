-- =============================================================================
--  MamaFlyNest — The Binding of Isaac: Repentance
--  Mama Flies (Type=56) continuously spawn Attack Flies every 10 seconds.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MamaFlyNest", 1)
local mamaTimers = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= 56 then return end

    local idx = GetPtrHash(npc)
    mamaTimers[idx] = (mamaTimers[idx] or 0) + 1

    if mamaTimers[idx] >= 300 then
        mamaTimers[idx] = 0
        local pos = npc.Position
        for i = 1, 2 do
            local offset = Vector(math.random(-30, 30), math.random(-30, 30))
            local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, pos + offset, Vector.Zero, npc)
            if fly then
                fly.Velocity = Vector(math.random(-2, 2), math.random(-2, 2))
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("MamaFlyNest loaded!")
