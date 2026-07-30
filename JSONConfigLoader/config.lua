-- config.lua — JSONConfigLoader configuration file
-- Users can edit these values to customize game behavior.
-- This file uses Lua table syntax (equivalent to JSON for this purpose).
return {
    damageMultiplier = 1.0,   -- 1.0 = normal, 2.0 = double damage
    speedMultiplier = 1.0,    -- 1.0 = normal, 1.5 = 50% faster
    tearMultiplier = 1.0,     -- 1.0 = normal, 0.5 = half tear delay
    luckBonus = 0,            -- Extra luck added to player
    enableStatDisplay = true, -- Show config overlay with F5 key
}
