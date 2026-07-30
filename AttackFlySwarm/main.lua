-- =============================================================================
--  AttackFlySwarm — The Binding of Isaac: Repentance
--  Attack Flies (Type=62) spawn 3 miniature flies when hit.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("AttackFlySwarm", 1)

function mod:onTakeDmg(target, amount, flags, source, countdown)
    if target.Type == 62 then
        local pos = target.Position
        for i = 1, 3 do
            local vel = Vector(math.random(-3, 3), math.random(-3, 3))
            local fly = Isaac.Spawn(EntityType.ENTITY_ATTACKFLY, 0, 0, pos, vel, target)
            if fly then
                fly.Scale = 0.6
                fly:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.onTakeDmg)
Isaac.DebugString("AttackFlySwarm loaded!")
