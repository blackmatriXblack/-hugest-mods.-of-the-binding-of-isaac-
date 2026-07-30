-- ==========================================================================
--  The Shell Defense - The Binding of Isaac: Repentance
--  The Shell spins creating a whirlpool defense that reflects tears.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TheShellDefense", 1)
local SHELL_ID = 871 -- The Shell entity ID
local WHIRLPOOL_DURATION = 120
local tearReflectEntities = {}

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_GURGLING and npc.Variant == 2 then -- The Shell
        local room = Game():GetRoom()
        if not room then return end

        -- Shell periodically enters whirlpool defense phase
        if npc.FrameCount % 300 > 0 and npc.FrameCount % 300 < WHIRLPOOL_DURATION then
            npc:AddEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)

            -- Reflect all player tears in the room
            local entities = Isaac.GetRoomEntities()
            for _, ent in ipairs(entities) do
                if ent.Type == EntityType.ENTITY_TEAR and ent:ToTear() then
                    local tear = ent:ToTear()
                    if tear.FallingSpeed < 0 or tear:GetSprite():IsPlaying("Travel") then
                        -- Reflect tear back toward player
                        local player = Isaac.GetPlayer(0)
                        if player then
                            local toPlayer = player.Position - tear.Position
                            tear.Velocity = -tear.Velocity * 1.2
                            tear.FallingSpeed = -tear.FallingSpeed
                            tearReflectEntities[ent.Index] = true
                        end
                    end
                end
            end

            -- Visual whirlpool spin effect
            npc.Velocity = npc.Velocity * 0.85
        elseif npc.FrameCount % 300 == WHIRLPOOL_DURATION then
            npc:ClearEntityFlags(EntityFlag.FLAG_NO_SPRITE_UPDATE)
        end
    end
end)

Isaac.DebugString("TheShellDefense loaded!")
