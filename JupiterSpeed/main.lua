-- =============================================================================
--  Jupiter Speed - The Binding of Isaac: Repentance
--  Jupiter (651) grants +0.3 speed per poison kill, caps at +1.5.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("JupiterSpeed", 1)
local COLLECTIBLE_JUPITER = 651
local SPEED_PER_KILL = 0.3
local MAX_SPEED_BONUS = 1.5

function mod:OnPeffectUpdate(player)
    if player:HasCollectible(COLLECTIBLE_JUPITER) then
        local data = player:GetData()
        if not data.jupiterSpeedBonus then
            data.jupiterSpeedBonus = 0
        end
        if data.jupiterSpeedBonus > 0 then
            player.MoveSpeed = player.MoveSpeed + math.min(data.jupiterSpeedBonus, MAX_SPEED_BONUS)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPeffectUpdate)
Isaac.DebugString("JupiterSpeed loaded!")
