-- ==========================================================================
--  UltraPrideMinionEnrage - The Binding of Isaac: Repentance
--  Ultra Pride's minions enrage when Ultra Pride dies
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("UltraPrideMinionEnrage", 1)
local game = Game()
local ULTRA_PRIDE_TYPE = EntityType.ENTITY_ULTRA_PRIDE

function mod:enrageDeath(_, npc)
    if npc.Type ~= ULTRA_PRIDE_TYPE then return end
    local ents = Isaac.GetRoomEntities()
    for _, ent in ipairs(ents) do
        if ent.Type == npc.Type and ent.Variant ~= npc.Variant then
            ent:AddEntityFlags(EntityFlag.FLAG_ENRAGED)
            ent.Size = ent.Size * 1.3
            local spr = ent:GetSprite()
            spr.Color = Color(1, 0.3, 0.1, 1, 0, 0, 0)
            ent:AddBurn(EntityRef(npc), 9999, 0)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, mod.enrageDeath, ULTRA_PRIDE_TYPE)
Isaac.DebugString("UltraPrideMinionEnrage loaded!")
