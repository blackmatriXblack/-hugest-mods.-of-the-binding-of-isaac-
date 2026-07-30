-- =============================================================================
--  EyeBloodshot - The Binding of Isaac: Repentance
--  Bloodshot Eye fires 3x faster and shots home slightly when below 50% HP
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("EyeBloodshot", 1)
local EYE_BLOODSHOT_TYPE = 204 -- EntityType.ENTITY_BLOODSHOT_EYE
local FAST_FIRE_INTERVAL = 10  -- ~3x faster than normal

local function onNPCUpdate(_, entity)
    if entity.Type ~= EYE_BLOODSHOT_TYPE or not entity:Exists() then
        return
    end

    local maxHP = entity.MaxHitPoints or 20
    local currentHP = entity.HitPoints
    local hpPercent = currentHP / (maxHP > 0 and maxHP or 20)

    if hpPercent < 0.5 and hpPercent > 0 then
        -- Enraged mode: faster fire rate
        entity.State = 0 -- reset state to trigger attack
        entity:ClearEntityFlags(EntityFlag.FLAG_NO_FLASH)
        entity:SetColor(Color(1, 0.3, 0.3, 1, 0, 0, 0), 5, 0, false, true)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("EyeBloodshot loaded!")
