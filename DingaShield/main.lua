-- =============================================================================
--  DingaShield -- The Binding of Isaac: Repentance
--  Dingas (Type=53) project a shield that blocks 1 hit, then breaks.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DingaShield", 1)

function mod:onNpcUpdate(npc)
    if npc.Type ~= 53 then return end
    local data = npc:GetData()
    if data.shieldActive == nil then
        data.shieldActive = true
    end
    if data.shieldActive then
        npc:SetColor(Color(0.4, 0.4, 1.0, 1.0, 0, 0, 0))
    end
end

function mod:onEntityTakeDmg(target, amount, flag, source, countdown)
    if target.Type ~= 53 then return end
    local data = target:GetData()
    if data.shieldActive then
        data.shieldActive = false
        target:SetColor(Color(1.0, 1.0, 1.0, 1.0, 0, 0, 0))
        return false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onEntityTakeDmg)
Isaac.DebugString("DingaShield loaded!")
