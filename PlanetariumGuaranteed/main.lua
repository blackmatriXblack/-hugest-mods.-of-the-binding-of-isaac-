-- =============================================================================
--  PlanetariumGuaranteed — The Binding of Isaac: Repentance
--  Planetariums always appear after skipping 1 treasure room.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PlanetariumGuaranteed", 1)

local treasureRoomSkipped = false

function mod:TrackTreasureRoomSkip()
    local room = Game():GetRoom()
    if room:GetType() == RoomType.ROOM_TREASURE then
        treasureRoomSkipped = true
    end
end

function mod:BoostPlanetariumChance()
    if treasureRoomSkipped then
        local level = Game():GetLevel()
        level:SetPlanetariumChance(100)
        treasureRoomSkipped = false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.TrackTreasureRoomSkip)
mod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, mod.BoostPlanetariumChance)
Isaac.DebugString("PlanetariumGuaranteed loaded!")
