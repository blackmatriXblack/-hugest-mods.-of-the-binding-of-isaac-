-- ==========================================================================
--  Mega Satan Hand Left - The Binding of Isaac: Repentance
--  Mega Satan's left hand spawns Dark Ones instead of normal enemies.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MegaSatanHandLeft", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_MEGA_SATAN then
        local room = Game():GetRoom()
        local player = Isaac.GetPlayer(0)
        if not room or not player then return end

        if npc.FrameCount % 75 == 0 then
            for i = 1, 2 do
                local spawnPos = room:FindFreePickupSpawnPosition(
                    npc.Position + Vector((i - 1.5) * 80, -40), 30, true)
                local darkOne = Isaac.Spawn(EntityType.ENTITY_DARK_ONE, 0, 0,
                    spawnPos, Vector.Zero, npc)
                if darkOne then
                    darkOne:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
                end
            end
        end
    end
end)

Isaac.DebugString("MegaSatanHandLeft loaded!")
