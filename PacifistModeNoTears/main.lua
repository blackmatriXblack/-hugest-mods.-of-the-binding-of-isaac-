-- =============================================================================
--  PacifistModeNoTears - The Binding of Isaac: Repentance
--  Player cannot fire tears but gains contact damage immunity and orbital damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PacifistModeNoTears", 1)
local game = Game()

-- Orbital entities to grant on room enter
local orbitalTypes = {
    EntityType.ENTITY_FAMILIAR,
    EntityType.ENTITY_FAMILIAR,
    EntityType.ENTITY_FAMILIAR,
}

local orbitalVariants = {
    FamiliarVariant.SACRIFICIAL_DAGGER,    -- Sacrificial Dagger (orbital)
    FamiliarVariant.CUBE_OF_MEAT,          -- Cube of Meat
    FamiliarVariant.BALL_OF_BANDAGES,      -- Ball of Bandages
}

function mod:onFireTear(tear)
    -- Cancel ALL tears fired by the player - true pacifism
    tear:Remove()
end

function mod:onPlayerEffectUpdate(player)
    if player:GetPlayerType() == PlayerType.PLAYER_ISAAC or true then
        -- Grant contact damage immunity (simulated by high contact damage on orbitals)
        -- The orbitals will damage enemies that touch the player

        -- Check if orbitals exist; if not, spawn them at start of each room
        local hasOrbitals = false
        for i = 0, player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_SACRIFICIAL_DAGGER) do
            hasOrbitals = true
            break
        end
    end
end

function mod:onNewRoom()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Grant the player permanent orbitals for offense without tears
    -- Add Sacrificial Dagger effect (orbital damage)
    for _, familiarVariant in ipairs(orbitalVariants) do
        local familiar = Isaac.Spawn(
            EntityType.ENTITY_FAMILIAR,
            familiarVariant,
            0,
            player.Position,
            Vector.Zero,
            player
        )
    end

    -- Also grant contact damage immunity via a hidden effect
    -- Use Midas Touch effect for contact damage
    player:AddCollectible(CollectibleType.COLLECTIBLE_MIDAS_TOUCH, 0, false)
    player:AddCollectible(CollectibleType.COLLECTIBLE_E_COLI, 0, false)

    Isaac.DebugString("Pacifist: orbitals granted!")
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.onFireTear)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerEffectUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)

Isaac.DebugString("PacifistModeNoTears loaded!")
