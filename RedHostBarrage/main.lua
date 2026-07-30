-- =============================================================================
--  RedHostBarrage — The Binding of Isaac: Repentance
--  Red Hosts (Type=15, Variant=1) fire 5 shots instead of 3.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RedHostBarrage", 1)

local SHOT_COUNT = 5
local EXTRA_SHOTS = 2
local FIRING_STATE = 2  -- State when the host opens skull and fires

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= 15 or npc.Variant ~= 1 then return end

    -- When the host enters the firing state, add extra projectiles
    if npc.State == FIRING_STATE and npc.StateFrame == 0 then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        local baseDir = (player.Position - npc.Position):Normalized()
        local spreadAngle = math.pi / 12  -- 15-degree spread

        for i = 1, EXTRA_SHOTS do
            local angle = (i - (EXTRA_SHOTS + 1) / 2) * spreadAngle
            local dir = baseDir:Rotated(angle)
            local tear = Isaac.Spawn(
                EntityType.ENTITY_PROJECTILE, 0, 0,
                npc.Position, dir * 6, npc
            )
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("RedHostBarrage loaded!")
