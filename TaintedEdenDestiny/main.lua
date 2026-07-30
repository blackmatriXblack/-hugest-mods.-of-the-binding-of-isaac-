-- =============================================================================
--  TaintedEdenDestiny - The Binding of Isaac: Repentance
--  Tainted Eden: Starts with random +3 passive items.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TaintedEdenDestiny", 1)
local TAINTED_EDEN = 30

local PASSIVE_POOL = {
    CollectibleType.COLLECTIBLE_SAD_ONION,
    CollectibleType.COLLECTIBLE_INNER_EYE,
    CollectibleType.COLLECTIBLE_SPOON_BENDER,
    CollectibleType.COLLECTIBLE_MAXS_HEAD,
    CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM,
    CollectibleType.COLLECTIBLE_CROWN_OF_LIGHT,
    CollectibleType.COLLECTIBLE_DARK_MATTER,
    CollectibleType.COLLECTIBLE_PENTAGRAM,
    CollectibleType.COLLECTIBLE_GROWTH_HORMONES,
    CollectibleType.COLLECTIBLE_STEVEN,
    CollectibleType.COLLECTIBLE_BLOOD_OF_THE_MARTYR,
    CollectibleType.COLLECTIBLE_HALO,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_THIN,
    CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE,
    CollectibleType.COLLECTIBLE_MOMS_HEELS,
    CollectibleType.COLLECTIBLE_MOMS_LIPSTICK,
    CollectibleType.COLLECTIBLE_MOMS_UNDERWEAR,
    CollectibleType.COLLECTIBLE_MOMS_BRA,
    CollectibleType.COLLECTIBLE_BELT,
    CollectibleType.COLLECTIBLE_WOODEN_SPOON,
}

function mod:onPlayerInit(player)
    if player:GetPlayerType() ~= TAINTED_EDEN then return end

    local rng = RNG()
    rng:SetSeed(player:GetDropRNG():Next(), 0)

    for i = 1, 3 do
        local idx = (rng:Next() % #PASSIVE_POOL) + 1
        local item = PASSIVE_POOL[idx]
        player:AddCollectible(item, 0, false)
        Isaac.DebugString("TaintedEdenDestiny: Added item " .. tostring(item))
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, mod.onPlayerInit)
Isaac.DebugString("TaintedEdenDestiny loaded!")
