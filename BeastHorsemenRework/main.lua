-- =============================================================================
--  BeastHorsemenRework — The Binding of Isaac: Repentance
--  Ultra Horsemen have unique abilities and drop random trinkets on death.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BeastHorsemenRework", 1)

local ULTRA_FAMINE = 951
local ULTRA_WAR    = 952
local ULTRA_PEST   = 953
local ULTRA_DEATH  = 954

local HORSEMEN = {
    [ULTRA_FAMINE] = true,
    [ULTRA_WAR]    = true,
    [ULTRA_PEST]   = true,
    [ULTRA_DEATH]  = true,
}

function mod:OnEntityKill(entity)
    if HORSEMEN[entity.Type] then
        -- Drop a random trinket on death
        local pos = entity.Position
        local rng = RNG()
        rng:SetSeed(entity.InitSeed, 0)
        local trinketList = {
            TrinketType.TRINKET_CANCER,
            TrinketType.TRINKET_CURVED_HORN,
            TrinketType.TRINKET_GOAT_HOOF,
            TrinketType.TRINKET_CALLUS,
            TrinketType.TRINKET_ROSARY_BEAD,
            TrinketType.TRINKET_CHILDS_LEASH,
            TrinketType.TRINKET_BLOODY_CROWN,
            TrinketType.TRINKET_PERFECTION,
            TrinketType.TRINKET_STEM_CELL,
            TrinketType.TRINKET_BROKEN_SYRINGE,
        }
        local idx = rng:RandomInt(#trinketList) + 1
        Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, trinketList[idx], pos, Vector.Zero, entity)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.OnEntityKill)
Isaac.DebugString("BeastHorsemenRework loaded!")
