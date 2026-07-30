-- =============================================================================
--  PostPlayerDeathEvent - The Binding of Isaac: Repentance
--  Spawns a random trinket at death location for "next run" flavor.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostPlayerDeathEvent", 1)

function mod:onPostPlayerDeath(player)
    local trinkets = {
        TrinketType.TRINKET_SWALLOWED_PENNY, TrinketType.TRINKET_PETRIFIED_POOP,
        TrinketType.TRINKET_BUTT_PENNY, TrinketType.TRINKET_MYSTERIOUS_PAPER,
        TrinketType.TRINKET_BROKEN_MAGNET, TrinketType.TRINKET_BROKEN_REMOTE,
        TrinketType.TRINKET_KIDS_DRAWING, TrinketType.TRINKET_HAIRPIN,
        TrinketType.TRINKET_WOODEN_CROSS, TrinketType.TRINKET_BLESSED_PENNY,
        TrinketType.TRINKET_CURVED_HORN, TrinketType.TRINKET_NO
    }
    local trinketType = trinkets[math.random(1, #trinkets)]
    local pos = player.Position
    Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinketType, pos, Vector(0, -1), nil)
    Isaac.DebugString("A trinket drops as a final gift...")
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_DEATH, mod.onPostPlayerDeath)
Isaac.DebugString("PostPlayerDeathEvent loaded!")
