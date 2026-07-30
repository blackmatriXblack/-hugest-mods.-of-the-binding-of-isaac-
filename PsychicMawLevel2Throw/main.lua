-- ==========================================================================
--  PsychicMawLevel2Throw - The Binding of Isaac: Repentance
--  Level 2 Psychic Maw telekinetically throws nearby rocks/debris at player.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("PsychicMawLevel2Throw", 1)
local ENEMY_PSYCHIC_MAW = 244
local THROW_INTERVAL = 120
local THROW_RANGE = 200

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_PSYCHIC_MAW or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.throwTimer then data.throwTimer = 0 end

    data.throwTimer = data.throwTimer + 1
    if data.throwTimer >= THROW_INTERVAL then
        data.throwTimer = 0
        local player = Isaac.GetPlayer(0)
        if player then
            local playerPos = player.Position
            -- Find nearby grid entities (rocks) and throw them
            local room = Game():GetRoom()
            for x = 0, room:GetGridWidth() - 1 do
                for y = 0, room:GetGridHeight() - 1 do
                    local grid = room:GetGridEntity(x, y)
                    if grid ~= nil then
                        local gridType = grid:GetType()
                        if gridType == GridEntityType.GRID_ROCK or gridType == GridEntityType.GRID_ROCKB then
                            local gridPos = room:GetGridPosition(x, y)
                            local dist = gridPos:Distance(npc.Position)
                            if dist < THROW_RANGE and gridPos:Distance(playerPos) > 30 then
                                -- Destroy rock and spawn a rock projectile toward player
                                room:RemoveGridEntity(x, y, 0, false)
                                local dir = (playerPos - gridPos):Normalized()
                                local rock = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, gridPos, dir * 6, npc)
                                if rock and rock.Exists() then
                                    rock:ToEffect()
                                    rock.Timeout = 60
                                end
                                -- Only throw one rock per cycle
                                goto thrown
                            end
                        end
                    end
                end
            end
            ::thrown::
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("PsychicMawLevel2Throw loaded!")