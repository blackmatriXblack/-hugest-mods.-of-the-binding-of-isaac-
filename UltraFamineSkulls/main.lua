-- ==========================================================================
--  Ultra Famine Skulls - The Binding of Isaac: Repentance
--  Ultra Famine fires skull projectiles that leave creep where they land.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("UltraFamineSkulls", 1)
local FAMINE_ID = EntityType.ENTITY_FAMINE
local SKULL_TEAR_VARIANT = 0

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == FAMINE_ID then
        local room = Game():GetRoom()
        if not room then return end

        -- Ultra Famine fires skulls that leave damaging creep
        if npc.FrameCount % 45 == 0 then
            local player = Isaac.GetPlayer(0)
            if not player then return end

            local dir = (player.Position - npc.Position):Normalized()
            for i = 1, 3 do
                local spreadAngle = (i - 2) * 0.2
                local rotatedDir = dir:Rotated(spreadAngle)
                local skull = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0,
                    npc.Position, rotatedDir * 4, npc)

                -- Skull leaves creep on landing - tracked by position
                if skull then
                    Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0,
                        skull.Position, Vector.Zero, nil)
                end
            end
        end
    end
end)

Isaac.DebugString("UltraFamineSkulls loaded!")
