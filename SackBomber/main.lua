-- =============================================================================
--  SackBomber -- The Binding of Isaac: Repentance
--  Sacks (Type=59) explode into 6 bombs on death instead of spawning spiders.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SackBomber", 1)

function mod:onEntityKill(target)
    if target.Type ~= 59 then return end
    local pos = target.Position
    for i = 1, 6 do
        local angle = (i - 1) * math.pi * 2 / 6
        local vel = Vector(math.cos(angle) * 3, math.sin(angle) * 3)
        Isaac.Spawn(EntityType.ENTITY_BOMB, BombVariant.BOMB_NORMAL, 0, pos, vel, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("SackBomber loaded!")
