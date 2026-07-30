-- =============================================================================
--  EVERY ROOM DROPS — The Binding of Isaac: Repentance
--  Every room you enter spawns items! Pedestals, cards, trinkets, pills, more.
--  Version: 1.0   |   Repentance only
-- =============================================================================

local mod = RegisterMod("EveryRoomDrops", 1)
local game = Game()
local rng = RNG()
rng:SetSeed(math.floor(os.time()), 0)

-- =============================================================================
--  CONSTANTS
-- =============================================================================
local ENTITY_PICKUP       = 5
local VAR_COLLECTIBLE     = 100   -- Pedestal item
local VAR_TAROT_CARD      = 300   -- Card / Rune / Soul Stone
local VAR_TRINKET         = 350   -- Trinket
local VAR_PILL            = 70    -- Pill
local VAR_LIL_BATTERY     = 90    -- Battery
local VAR_GOLDEN_BOMB     = 51    -- Golden Bomb (1+7 variant)
local VAR_GOLDEN_KEY      = 31    -- Golden Key
local VAR_SACK            = 69    -- Grab bag
local VAR_CHEST           = 360   -- Chest (random drops)

-- Room types where items WILL spawn
local ALLOWED_ROOMS = {
    [1]  = true,  -- ROOM_DEFAULT
    [9]  = true,  -- ROOM_ARCADE
    [11] = true,  -- ROOM_CHALLENGE
    [12] = true,  -- ROOM_LIBRARY
    [16] = true,  -- ROOM_DUNGEON
    [19] = true,  -- ROOM_BARREN
    [21] = true,  -- ROOM_DICE
}

-- =============================================================================
--  ITEM POOL MAP — different room types get different item pools
-- =============================================================================
local POOL_TREASURE = 0
local POOL_SHOP     = 1
local POOL_BOSS     = 2
local POOL_DEVIL    = 3
local POOL_ANGEL    = 4
local POOL_SECRET   = 5
local POOL_LIBRARY  = 6
local POOL_CURSE    = 8
local POOL_GOLDEN   = 10
local POOL_PLANET   = 25

local ROOM_POOL = {
    [1]  = POOL_TREASURE,   -- Normal room → treasure pool
    [9]  = POOL_SHOP,       -- Arcade → shop / trinkets
    [11] = POOL_BOSS,       -- Challenge room → boss items (reward for danger!)
    [12] = POOL_LIBRARY,    -- Library → book / angel items
    [16] = POOL_SECRET,     -- Crawlspace → secret pool
    [19] = POOL_TREASURE,   -- Barren room → treasure pool
    [21] = POOL_GOLDEN,     -- Dice room → golden chest / rare pool
}

-- =============================================================================
--  HELPERS
-- =============================================================================
local function randomRange(min, max)
    return min + rng:RandomInt(max - min + 1)
end

local function chance(percent)
    return rng:RandomInt(100) < percent
end

local function spreadPositions(center, count, spacing)
    local positions = {}
    for i = 0, count - 1 do
        local x = center.X + (i - (count - 1) / 2) * spacing
        positions[i + 1] = Vector(x, center.Y)
    end
    return positions
end

-- =============================================================================
--  SPAWN FUNCTIONS
-- =============================================================================
local function spawnCollectible(pos, poolType)
    local itemPool = game:GetItemPool()
    local id = itemPool:GetCollectible(poolType, true, rng:Next())
    if id and id > 0 then
        local e = Isaac.Spawn(ENTITY_PICKUP, VAR_COLLECTIBLE, id, pos, Vector(0, 0), nil)
        return e
    end
    return nil
end

local function spawnCard(pos)
    local itemPool = game:GetItemPool()
    local id = itemPool:GetCard(rng:Next())
    if id and id > 0 then
        Isaac.Spawn(ENTITY_PICKUP, VAR_TAROT_CARD, id, pos, Vector(0, 0), nil)
    end
end

local function spawnTrinket(pos)
    local itemPool = game:GetItemPool()
    local id = itemPool:GetTrinket()
    if id and id > 0 then
        Isaac.Spawn(ENTITY_PICKUP, VAR_TRINKET, id, pos, Vector(0, 0), nil)
    end
end

local function spawnPill(pos)
    local itemPool = game:GetItemPool()
    local id = itemPool:GetPillEffect(rng:Next())
    Isaac.Spawn(ENTITY_PICKUP, VAR_PILL, id, pos, Vector(0, 0), nil)
end

local function spawnConsumable(pos)
    local roll = rng:RandomInt(5)
    if roll == 0 then
        Isaac.Spawn(ENTITY_PICKUP, VAR_LIL_BATTERY, 0, pos, Vector(0, 0), nil)
    elseif roll == 1 then
        Isaac.Spawn(ENTITY_PICKUP, VAR_SACK, 0, pos, Vector(0, 0), nil)
    elseif roll == 2 then
        -- Golden Bomb (drops a bomb + bomb item effect)
        Isaac.Spawn(ENTITY_PICKUP, VAR_GOLDEN_BOMB, 0, pos, Vector(0, 0), nil)
    elseif roll == 3 then
        -- Golden Key (drops a key + key item effect)
        Isaac.Spawn(ENTITY_PICKUP, VAR_GOLDEN_KEY, 0, pos, Vector(0, 0), nil)
    else
        -- Random chest
        Isaac.Spawn(ENTITY_PICKUP, VAR_CHEST, rng:RandomInt(4), pos, Vector(0, 0), nil)
    end
end

local function spawnBlessedCollectible(pos, poolType)
    -- Blessed pedestal: higher chance of angel/devil quality
    local altPool = chance(50) and POOL_ANGEL or POOL_DEVIL
    return spawnCollectible(pos, altPool)
end

-- =============================================================================
--  Check if room already has collectible pedestals (avoid double-spawning)
-- =============================================================================
local function roomHasPedestal()
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e.Type == ENTITY_PICKUP and e.Variant == VAR_COLLECTIBLE then
            return true
        end
    end
    return false
end

-- =============================================================================
--  Determine item count by room shape
-- =============================================================================
local function getItemCount(shape, roomType)
    local base = 1

    if shape == 2 or shape == 3 then
        base = randomRange(1, 2)
    elseif shape >= 5 and shape <= 8 then
        base = randomRange(2, 3)
    elseif shape >= 9 then
        base = randomRange(3, 5)
    end

    -- Arcade rooms: +1 extra loot
    if roomType == 9 then
        base = base + 1
    end

    return base
end

-- =============================================================================
--  Spawn a single loot drop (random type)
-- =============================================================================
local function spawnOneLoot(pos, poolType, roomType)
    local roll = rng:RandomInt(100)

    if roll < 55 then
        -- 55%: Collectible pedestal (treasure / room pool)
        spawnCollectible(pos, poolType)
    elseif roll < 70 then
        -- 15%: Bonus item from shop pool
        spawnCollectible(pos, POOL_SHOP)
    elseif roll < 80 then
        -- 10%: Card / Rune / Soul Stone
        spawnCard(pos)
    elseif roll < 90 then
        -- 10%: Trinket
        spawnTrinket(pos)
    elseif roll < 95 then
        -- 5%: Pill
        spawnPill(pos)
    else
        -- 5%: Consumable (battery, sack, golden bomb/key, chest)
        spawnConsumable(pos)
    end
end

-- =============================================================================
--  MAIN CALLBACK — on every room entry
-- =============================================================================
function mod:onNewRoom()
    local room = game:GetLevel():GetCurrentRoom()
    if room == nil then return end

    local roomType = room:GetType()
    if not ALLOWED_ROOMS[roomType] then return end

    -- Avoid double-spawning in rooms that already have pedestals (treasure rooms, etc.)
    -- Note: we still spawn non-collectible drops even if a pedestal exists
    local hasPedestal = roomHasPedestal()
    local shape = room:GetRoomShape()
    local poolType = ROOM_POOL[roomType] or POOL_TREASURE
    local count = getItemCount(shape, roomType)
    local center = room:GetCenterPos()

    -- ====== JACKPOT ROOM (5% chance) ======
    if chance(5) and not hasPedestal then
        -- Spawn 4 collectibles in a diamond
        local offsets = {
            Vector(0, -80),   -- top
            Vector(-80, 0),   -- left
            Vector(80, 0),    -- right
            Vector(0, 80),    -- bottom
        }
        for _, offset in ipairs(offsets) do
            spawnCollectible(Vector(center.X + offset.X, center.Y + offset.Y), poolType)
        end
        Isaac.DebugString("JACKPOT ROOM! 4 free items!")
        return
    end

    -- ====== CHOICE ROOM (12% chance) ======
    if chance(12) and not hasPedestal and count >= 1 then
        -- Two different items, side by side
        local left  = Vector(center.X - 60, center.Y)
        local right = Vector(center.X + 60, center.Y)
        spawnCollectible(left, poolType)
        spawnCollectible(right, poolType)
        count = count - 1  -- still spawn the rest as bonus loot
    end

    -- ====== BLESSED PEDESTAL (8% chance, only if no pedestal yet) ======
    if not hasPedestal and chance(8) then
        spawnBlessedCollectible(center, poolType)
        hasPedestal = true
        count = count - 1
    end

    -- ====== NORMAL LOOT SPAWNING ======
    if count <= 0 then return end

    local positions = spreadPositions(center, count, 90)

    for i = 1, count do
        pos = positions[i]

        -- If first item and no pedestal yet, prioritize a collectible
        if i == 1 and not hasPedestal then
            spawnCollectible(pos, poolType)
            hasPedestal = true
        else
            spawnOneLoot(pos, poolType, roomType)
        end
    end
end

-- =============================================================================
--  REGISTER
-- =============================================================================
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
