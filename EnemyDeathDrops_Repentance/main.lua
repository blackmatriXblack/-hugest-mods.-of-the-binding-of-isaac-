-- =============================================================================
--  ENEMY DEATH DROPS — The Binding of Isaac: Repentance
--  Every enemy you kill drops random items! Collectibles, cards, trinkets,
--  pills, pickups — the carnage fuels your power.
--  Version: 1.0   |   Repentance only
-- =============================================================================

local mod = RegisterMod("EnemyDeathDrops", 1)
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
local VAR_COIN            = 20    -- Coin
local VAR_BOMB            = 40    -- Bomb
local VAR_KEY             = 30    -- Key
local VAR_HEART_RED       = 10    -- Red heart

-- Item pools
local POOL_TREASURE = 0
local POOL_SHOP     = 1
local POOL_BOSS     = 2
local POOL_DEVIL    = 3
local POOL_ANGEL    = 4
local POOL_SECRET   = 5
local POOL_CURSE    = 8
local POOL_GOLDEN   = 10

-- =============================================================================
--  HELPERS
-- =============================================================================
local function chance(percent)
    return rng:RandomInt(100) < percent
end

local function randomPick(tbl)
    return tbl[rng:RandomInt(#tbl) + 1]
end

-- =============================================================================
--  SPAWN FUNCTIONS
-- =============================================================================
local function spawnCollectible(pos, poolType)
    local itemPool = game:GetItemPool()
    local id = itemPool:GetCollectible(poolType, true, rng:Next())
    if id and id > 0 then
        return Isaac.Spawn(ENTITY_PICKUP, VAR_COLLECTIBLE, id, pos, Vector(0, 0), nil)
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
        Isaac.Spawn(ENTITY_PICKUP, VAR_GOLDEN_BOMB, 0, pos, Vector(0, 0), nil)
    elseif roll == 3 then
        Isaac.Spawn(ENTITY_PICKUP, VAR_GOLDEN_KEY, 0, pos, Vector(0, 0), nil)
    else
        Isaac.Spawn(ENTITY_PICKUP, VAR_CHEST, rng:RandomInt(4), pos, Vector(0, 0), nil)
    end
end

local function spawnPickup(pos)
    local roll = rng:RandomInt(4)
    if roll == 0 then
        Isaac.Spawn(ENTITY_PICKUP, VAR_COIN, 1, pos, Vector(0, 0), nil)   -- Penny
    elseif roll == 1 then
        Isaac.Spawn(ENTITY_PICKUP, VAR_BOMB, 1, pos, Vector(0, 0), nil)   -- Bomb pickup
    elseif roll == 2 then
        Isaac.Spawn(ENTITY_PICKUP, VAR_KEY, 1, pos, Vector(0, 0), nil)    -- Key pickup
    else
        Isaac.Spawn(ENTITY_PICKUP, VAR_HEART_RED, 2, pos, Vector(0, 0), nil) -- Full red heart
    end
end

-- =============================================================================
--  Normal enemy drop
-- =============================================================================
local function dropNormalLoot(pos)
    local roll = rng:RandomInt(100)

    if roll < 30 then
        -- 30%: Basic pickup (coin/bomb/key/heart)
        spawnPickup(pos)
    elseif roll < 55 then
        -- 25%: Trinket
        spawnTrinket(pos)
    elseif roll < 75 then
        -- 20%: Card / Rune / Pill
        if chance(50) then
            spawnCard(pos)
        else
            spawnPill(pos)
        end
    elseif roll < 92 then
        -- 17%: Consumable (battery, sack, golden bomb/key, chest)
        spawnConsumable(pos)
    else
        -- 8%: Collectible pedestal — rare but possible!
        spawnCollectible(pos, POOL_TREASURE)
    end
end

-- =============================================================================
--  Champion enemy drop (better loot)
-- =============================================================================
local function dropChampionLoot(pos)
    local roll = rng:RandomInt(100)

    if roll < 15 then
        -- 15%: Basic pickup
        spawnPickup(pos)
    elseif roll < 35 then
        -- 20%: Trinket
        spawnTrinket(pos)
    elseif roll < 55 then
        -- 20%: Card / Rune / Pill
        if chance(50) then
            spawnCard(pos)
        else
            spawnPill(pos)
        end
    elseif roll < 80 then
        -- 25%: Consumable
        spawnConsumable(pos)
    else
        -- 20%: Collectible pedestal
        local pool = randomPick({POOL_TREASURE, POOL_BOSS, POOL_SHOP, POOL_SECRET})
        spawnCollectible(pos, pool)
    end
end

-- =============================================================================
--  Boss drop (guaranteed multi-drop)
-- =============================================================================
local function dropBossLoot(pos)
    local count = 2 + rng:RandomInt(3)  -- 2~4 items

    for _ = 1, count do
        local offsetX = rng:RandomInt(80) - 40
        local offsetY = rng:RandomInt(80) - 40
        local dropPos = Vector(pos.X + offsetX, pos.Y + offsetY)
        local roll = rng:RandomInt(100)

        if roll < 35 then
            -- 35%: Collectible pedestal
            local pool = randomPick({POOL_TREASURE, POOL_BOSS, POOL_DEVIL, POOL_ANGEL})
            spawnCollectible(dropPos, pool)
        elseif roll < 55 then
            -- 20%: Trinket
            spawnTrinket(dropPos)
        elseif roll < 70 then
            -- 15%: Card / Rune
            spawnCard(dropPos)
        elseif roll < 85 then
            -- 15%: Consumable
            spawnConsumable(dropPos)
        else
            -- 15%: Pill
            spawnPill(dropPos)
        end
    end
end

-- =============================================================================
--  MAIN CALLBACK — on every entity kill
-- =============================================================================
function mod:onEntityKill(entity)
    -- Safety check
    if entity == nil then return end

    -- Only trigger for enemies (not tears, pickups, effects, etc.)
    if not entity:IsEnemy() then return end

    local pos = entity.Position

    -- ====== BOSS KILL ======
    -- Boss is also an enemy, so check it first
    if entity:IsBoss() then
        dropBossLoot(pos)
        return
    end

    -- ====== CHAMPION ENEMY (65% drop chance, better loot) ======
    if entity:IsChampion() then
        if chance(65) then
            dropChampionLoot(pos)
        end
        return
    end

    -- ====== NORMAL ENEMY (40% drop chance) ======
    if chance(40) then
        dropNormalLoot(pos)
    end
end

-- =============================================================================
--  REGISTER
-- =============================================================================
mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
