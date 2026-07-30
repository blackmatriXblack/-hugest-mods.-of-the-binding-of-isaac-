-- ==========================================================================
--  Tainted Gemini Bond - The Binding of Isaac: Repentance
--  Tainted Gemini — twins within 100px heal rapidly.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedGeminiBond", 1)
local GEMINI_ID = EntityType.ENTITY_GEMINI

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == GEMINI_ID then
        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent.Type == GEMINI_ID and ent.Index ~= npc.Index then
                local dist = npc.Position:Distance(ent.Position)
                if dist < 100 then
                    local healAmt = math.floor(npc.MaxHitPoints * 0.01)
                    if healAmt > 0 then
                        npc:AddHealth(healAmt)
                        ent:ToNPC():AddHealth(healAmt)
                    end
                end
            end
        end
    end
end)

Isaac.DebugString("TaintedGeminiBond loaded!")
