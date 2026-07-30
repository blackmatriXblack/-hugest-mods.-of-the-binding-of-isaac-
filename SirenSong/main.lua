-- =============================================================================
--  Siren Song - The Binding of Isaac: Repentance
--  The Siren's song charms one of the player's active familiars for 5 seconds
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SirenSong", 1)
local SIREN_TYPE = 907 -- EntityType.ENTITY_SIREN

function mod:onNPCUpdate(npc)
    if npc.Type ~= SIREN_TYPE then return end
    
    -- Siren sings/charm state (state 8) - charm a random active familiar
    if npc.State == 8 and npc.StateFrame == 20 then
        local player = Isaac.GetPlayer(0)
        if not player then return end
        
        -- Find active familiars (incubus, succubus, etc.)
        local activeFamiliars = {}
        local roomEntities = Isaac.GetRoomEntities()
        for _, ent in ipairs(roomEntities) do
            if ent:IsFamiliar() and ent:ToFamiliar() then
                local fam = ent:ToFamiliar()
                if fam.Player == player and not fam:HasEntityFlags(EntityFlag.FLAG_FRIENDLY) then
                    table.insert(activeFamiliars, fam)
                end
            end
        end
        
        -- Charm one random familiar
        if #activeFamiliars > 0 then
            local target = activeFamiliars[math.random(#activeFamiliars)]
            -- Make familiar hostile temporarily - it shoots toward player
            target:GetData().charmed = true
            target:GetData().charmTimer = 150 -- 5 seconds at 30fps
            target:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
        end
    end
end

function mod:onFamiliarUpdate(familiar)
    if familiar:GetData().charmed then
        familiar:GetData().charmTimer = familiar:GetData().charmTimer - 1
        local player = Isaac.GetPlayer(0)
        
        -- Charmed familiar attacks player
        if player and familiar:GetData().charmTimer % 30 == 0 then
            local dir = (player.Position - familiar.Position):Normalized()
            Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, familiar.Position, dir * 3, familiar)
        end
        
        if familiar:GetData().charmTimer <= 0 then
            familiar:ClearEntityFlags(EntityFlag.FLAG_FRIENDLY)
            familiar:GetData().charmed = nil
            familiar:GetData().charmTimer = nil
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, SIREN_TYPE)
mod:AddCallback(ModCallbacks.MC_FAMILIAR_UPDATE, mod.onFamiliarUpdate)
Isaac.DebugString("SirenSong loaded!")
