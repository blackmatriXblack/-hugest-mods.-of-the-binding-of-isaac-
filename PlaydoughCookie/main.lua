-- =============================================================================
--  Playdough Cookie - The Binding of Isaac: Repentance
--  Playdough Cookie (645) tear effects cycle every 3 seconds instead of random.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PlaydoughCookie", 1)
local COLLECTIBLE_PLAYDOUGH_COOKIE = 645
local CYCLE_INTERVAL = 90  -- 3 seconds at 30fps

function mod:OnPeffectUpdate(player)
    if player:HasCollectible(COLLECTIBLE_PLAYDOUGH_COOKIE) then
        local data = player:GetData()
        if not data.playdoughTimer then
            data.playdoughTimer = 0
            data.playdoughEffect = 0
        end
        data.playdoughTimer = data.playdoughTimer + 1
        if data.playdoughTimer >= CYCLE_INTERVAL then
            data.playdoughTimer = 0
            data.playdoughEffect = (data.playdoughEffect + 1) % 4  -- Cycle through 4 effects
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.OnPeffectUpdate)
Isaac.DebugString("PlaydoughCookie loaded!")
