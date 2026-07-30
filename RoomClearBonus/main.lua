-- =============================================================================
--  ROOM CLEAR BONUS — The Binding of Isaac: Repentance
--  When a room is cleared, spawns a bonus reward:
--    30% treasure pedestal | 30% card | 20% trinket | 20% 3 random pickups
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RoomClearBonus", 1)
local roomCleared = false

function mod:onNewRoom()
    roomCleared = false
end

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if player == nil then return end

    local room = Game():GetRoom()
    if room == nil then return end

    if room:IsClear() and not roomCleared then
        roomCleared = true
        local pos = player.Position
        local roll = math.random(1, 100)

        if roll <= 30 then
            -- 30% chance: spawn treasure pedestal from current room's item pool
            Isaac.Spawn(5, 100, 0, pos, Vector(0, 0), nil)
        elseif roll <= 60 then
            -- 30% chance: spawn random card
            local cardSubtypes = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22}
            local cardSub = cardSubtypes[math.random(1, #cardSubtypes)]
            Isaac.Spawn(5, 300, cardSub, pos, Vector(0, 0), nil)
        elseif roll <= 80 then
            -- 20% chance: spawn random trinket
            Isaac.Spawn(5, 350, 0, pos, Vector(0, 0), nil)
        else
            -- 20% chance: spawn 3 random pickups (coins, bombs, keys, hearts)
            local pickups = {
                {5, 20, 1},  -- penny
                {5, 40, 1},  -- bomb
                {5, 30, 1},  -- key
                {5, 10, 2},  -- half heart
            }
            for i = 1, 3 do
                local p = pickups[math.random(1, #pickups)]
                local offset = Vector(math.random(-40, 40), math.random(-40, 40))
                Isaac.Spawn(p[1], p[2], p[3], pos + offset, Vector(0, 0), nil)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("Room Clear Bonus loaded!")
