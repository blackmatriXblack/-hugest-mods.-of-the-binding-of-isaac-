-- ==========================================================================
--  Haemolacria Brimstone - The Binding of Isaac: Repentance
--  Brimstone tears burst into blood shots on impact when holding Haemolacria
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("HaemolacriaBrimstone", 1)
local game = Game()

local HAEMOLACRIA = CollectibleType.COLLECTIBLE_HAEMOLACRIA
local BRIMSTONE = CollectibleType.COLLECTIBLE_BRIMSTONE

function mod:onFireTear(tear)
    local player = Isaac.GetPlayer(0)
    if not player then return end

    if player:HasCollectible(HAEMOLACRIA) and player:HasCollectible(BRIMSTONE) then
        local vel = tear.Velocity
        for i = 0, 3 do
            local angle = math.pi * 0.5 * i + (vel:GetAngleDegrees() * math.pi / 180)
            local bloodTear = player:FireTear(tear.Position,
                Vector(math.cos(angle), math.sin(angle)) * 4, false, true, false)
            if bloodTear then
                bloodTear:ChangeVariant(TearVariant.BLOOD)
                bloodTear.Scale = 0.6
                bloodTear.CollisionDamage = player.Damage * 0.4
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.onFireTear)
Isaac.DebugString("HaemolacriaBrimstone loaded!")
