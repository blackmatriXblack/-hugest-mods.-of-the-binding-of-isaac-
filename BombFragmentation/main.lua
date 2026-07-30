-- =============================================================================
--  BombFragmentation - The Binding of Isaac: Repentance
--  Bombs explode into 12 fragment tears in all directions.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BombFragmentation", 1)

local FRAGMENT_COUNT = 12

function mod:onBombUpdate(bomb)
    if not bomb.Visible then return end

    -- Check if bomb is about to explode (Variant 0 = regular bomb, about to explode)
    if bomb:IsDead() then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        local pos = bomb.Position
        for i = 1, FRAGMENT_COUNT do
            local angle = math.rad(i * (360 / FRAGMENT_COUNT))
            local dir = Vector(math.cos(angle), math.sin(angle))
            -- Spread tears outward
            local velocity = dir * (5 + math.random() * 3)
            -- Spawn a tear entity at position
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, pos, velocity, player)
            if tear then
                tear.Scale = 0.5
                tear.Color = Color(1.0, 0.5, 0.0, 1.0, 0, 0, 0)
                tear.CollisionDamage = player.Damage * 0.5
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.onBombUpdate)
Isaac.DebugString("BombFragmentation loaded!")
