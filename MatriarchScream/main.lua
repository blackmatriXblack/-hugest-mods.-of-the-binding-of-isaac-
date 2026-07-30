-- =============================================================================
--  Matriarch Scream - The Binding of Isaac: Repentance
--  Matriarch screams periodically, fearing all player's familiars briefly
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MatriarchScream", 1)
local MATRIARCH_TYPE = 905 -- EntityType.ENTITY_MATRIARCH

function mod:onNPCUpdate(npc)
    if npc.Type ~= MATRIARCH_TYPE then return end
    
    -- Scream every 240 frames (4 seconds) during her scream state
    if npc.State == 6 and npc.StateFrame == 10 then
        local player = Isaac.GetPlayer(0)
        if not player then return end
        
        -- Stun all player familiars for 60 frames
        local roomEntities = Isaac.GetRoomEntities()
        for _, ent in ipairs(roomEntities) do
            if ent:IsFamiliar() and ent:ToFamiliar() then
                local familiar = ent:ToFamiliar()
                if familiar.Player == player then
                    -- Apply fear/stun by setting velocity to zero and adding freeze
                    familiar.Velocity = Vector.Zero
                    familiar:AddEntityFlags(EntityFlag.FLAG_FREEZE)
                    -- Remove freeze after 60 frames
                    familiar:GetData().stunTimer = 60
                end
            end
        end
    end
end

function mod:onFamiliarUpdate(familiar)
    if familiar:GetData().stunTimer then
        familiar:GetData().stunTimer = familiar:GetData().stunTimer - 1
        if familiar:GetData().stunTimer <= 0 then
            familiar:ClearEntityFlags(EntityFlag.FLAG_FREEZE)
            familiar:GetData().stunTimer = nil
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, MATRIARCH_TYPE)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.onFamiliarUpdate)
Isaac.DebugString("MatriarchScream loaded!")
