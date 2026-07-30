-- ==========================================================================
--  Drop Everything - The Binding of Isaac: Repentance
--  Player drops all held items on the floor when taking damage
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DropEverything", 1)
local game = Game()

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, function(tookDamage, entity, dmgAmount, dmgFlag, dmgSource, dmgCountdownFrames)
    -- Only react to player taking damage
    if entity.Type ~= EntityType.ENTITY_PLAYER then return end
    if dmgAmount <= 0 then return end

    local player = entity:ToPlayer()
    if not player then return end

    local room = game:GetRoom()
    local droppedCount = 0

    -- Drop all collectibles
    local collectibles = {}
    for i = 0, CollectibleType.NUM_COLLECTIBLES - 1 do
        if player:HasCollectible(CollectibleType(i)) then
            table.insert(collectibles, CollectibleType(i))
        end
    end

    -- Don't drop more than 10 items (to avoid crashing)
    local itemsToDrop = math.min(#collectibles, 10)

    for i = 1, itemsToDrop do
        local item = collectibles[math.random(#collectibles)]
        local spawnPos = room:FindFreePickupSpawnPosition(
            player.Position + Vector(math.random(-80, 80), math.random(-80, 80)),
            1, true)

        local pedestal = Isaac.Spawn(EntityType.ENTITY_PICKUP,
            PickupVariant.PICKUP_COLLECTIBLE, item,
            spawnPos, Vector(math.random(-3, 3), math.random(-3, 3)), nil)

        if pedestal then
            player:RemoveCollectible(item)
            droppedCount = droppedCount + 1
        end

        -- Remove this item from our list so we don't try again
        for j, col in ipairs(collectibles) do
            if col == item then
                table.remove(collectibles, j)
                break
            end
        end
    end

    if droppedCount > 0 then
        Isaac.DebugString(string.format("Dropped %d items from taking damage!", droppedCount))
        
        -- Dramatic effect
        local pos = player.Position
        for i = 1, 10 do
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF02,
                0, pos + Vector(math.random(-40, 40), math.random(-40, 40)),
                Vector.Zero, nil)
        end
    end

    return nil  -- Don't modify the damage, just react
end)

Isaac.DebugString("Drop Everything loaded!")
