-- ==========================================================================
--  Tainted Hush Gaper Wave - The Binding of Isaac: Repentance
--  Tainted Hush — Gaper waves are 3x larger.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedHushGaperWave", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_HUSH then
        local room = Game():GetRoom()
        if not room then return end

        if npc.FrameCount % 80 == 0 then
            for i = 1, 9 do
                local angle = (i / 9) * math.pi * 2
                local spawnPos = room:GetCenterPos() + Vector.FromAngle(angle) * 200
                local gaper = Isaac.Spawn(EntityType.ENTITY_GAPER, 0, 0,
                    spawnPos, Vector.FromAngle(angle + math.pi) * 2, npc)
                if gaper then
                    gaper:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
                end
            end
        end
    end
end)

Isaac.DebugString("TaintedHushGaperWave loaded!")
