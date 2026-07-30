-- =============================================================================
--  ScarredGaperFrenzy - The Binding of Isaac: Repentance
--  Scarred Gaper attacks 3x faster and leaves red creep when below 33% HP
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ScarredGaperFrenzy", 1)
local SCARRED_TYPE = 5
local SCARRED_VARIANT = 2

function mod:OnTakeDamage(npc, amount, flags, source, countdown)
    if npc.Type == SCARRED_TYPE and npc.Variant == SCARRED_VARIANT then
        local hpPct = npc.HitPoints / npc.MaxHitPoints
        if hpPct <= 0.33 then
            local data = npc:GetData()
            data.frenzy = true
            npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        end
    end
end

function mod:OnNPCUpdate(npc)
    if npc.Type == SCARRED_TYPE and npc.Variant == SCARRED_VARIANT then
        local data = npc:GetData()
        if data.frenzy then
            -- Speed up attack animation by advancing StateFrame faster
            if npc.State == NpcState.STATE_ATTACK then
                npc.StateFrame = npc.StateFrame + 2
            end
            -- Leave red creep trail every 10 frames
            data.creepClock = (data.creepClock or 0) + 1
            if data.creepClock >= 10 then
                data.creepClock = 0
                Isaac.GridSpawn(GridEntityType.GRID_CREEP, 0, npc.Position, true)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakeDamage)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("ScarredGaperFrenzy loaded!")
