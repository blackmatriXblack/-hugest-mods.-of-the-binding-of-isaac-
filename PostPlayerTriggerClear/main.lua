-- =============================================================================
--  PostPlayerTriggerClear - The Binding of Isaac: Repentance
--  Drops random trinket every 5 room clears.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PostPlayerTriggerClear", 1)
local clearCount = 0

function mod:onPostPlayerTriggerClear()
    clearCount = (mod:GetSaveData(1) or 0) + 1
    mod:SetSaveData(1, clearCount)

    Isaac.DebugString("Rooms cleared: " .. clearCount)

    if clearCount % 5 == 0 then
        local trinkets = {
            TrinketType.TRINKET_SWALLOWED_PENNY, TrinketType.TRINKET_PETRIFIED_POOP,
            TrinketType.TRINKET_BUTT_PENNY, TrinketType.TRINKET_BROKEN_MAGNET,
            TrinketType.TRINKET_MYSTERIOUS_PAPER, TrinketType.TRINKET_BROKEN_REMOTE,
            TrinketType.TRINKET_KIDS_DRAWING, TrinketType.TRINKET_HAIRPIN,
            TrinketType.TRINKET_WOODEN_CROSS, TrinketType.TRINKET_CURVED_HORN,
            TrinketType.TRINKET_NO, TrinketType.TRINKET_FISH_HEAD
        }
        local trinketType = trinkets[math.random(1, #trinkets)]
        local player = Isaac.GetPlayer(0)
        local pos = player.Position + Vector(0, -30)
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinketType, pos, Vector.Zero, nil)
        Isaac.DebugString("Room clear milestone! Trinket dropped.")
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_TRIGGER_ROOM_CLEAR, mod.onPostPlayerTriggerClear)
Isaac.DebugString("PostPlayerTriggerClear loaded!")
