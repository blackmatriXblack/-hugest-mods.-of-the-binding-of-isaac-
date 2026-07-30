-- =============================================================================
--  Godhead Aura - The Binding of Isaac: Repentance
--  Godhead (331) aura radius is 2x larger.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GodheadAura", 1)

function mod:EnlargeAura(tear)
    -- Double the aura radius (original is 21, doubled is 42)
    tear:GetSprite().Scale = tear:GetSprite().Scale * 2
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.EnlargeAura)
Isaac.DebugString("GodheadAura loaded!")
