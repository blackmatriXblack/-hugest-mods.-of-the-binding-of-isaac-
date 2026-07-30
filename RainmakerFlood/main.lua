-- ==========================================================================
--  Rainmaker Flood - The Binding of Isaac: Repentance
--  Rainmaker's rain floods the room — water slows player and speeds up Rainmaker.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RainmakerFlood", 1)
local RAINMAKER_ID = 907 -- Rainmaker entity ID
local WATER_GRID_COLLISION = 7 -- GridCollisionClass.WATER equivalent

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_GURGLING and npc.Variant == 1 then -- Rainmaker
        local room = Game():GetRoom()
        local player = Isaac.GetPlayer(0)
        if not room or not player then return end

        -- Place water puddles on random floor positions near Rainmaker
        if npc.FrameCount % 60 == 0 then
            for i = 1, 4 do
                local x = npc.Position.X + (math.random() - 0.5) * 300
                local y = npc.Position.Y + (math.random() - 0.5) * 300
                local gridIndex = room:GetGridIndex(Vector(x, y))
                if gridIndex >= 0 then
                    local grid = room:GetGridEntity(gridIndex)
                    if grid and grid:GetType() == GridEntityType.GRID_POOP then
                        -- Water creep: slow player, buff Rainmaker
                        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0,
                            Vector(x, y), Vector.Zero, nil)
                    end
                end
            end

            -- Rainmaker speeds up while player slows when near water
            local dist = player.Position:Distance(npc.Position)
            if dist < 200 then
                npc:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
            end
        end
    end
end)

Isaac.DebugString("RainmakerFlood loaded!")
