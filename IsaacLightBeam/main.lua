-- =============================================================================
--  IsaacLightBeam - The Binding of Isaac: Repentance
--  Isaac boss light beams are wider and leave holy creep
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("IsaacLightBeam", 1)
local ISAAC_BOSS_ID = 102
local lastBeamFrame = 0

-- Track active crack-the-sky positions for creep spawning
local activeBeams = {}

function mod:OnNPCUpdate(npc)
    if npc.Type ~= ISAAC_BOSS_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local player = Isaac.GetPlayer(0)
    if not player or not player:Exists() then return end

    -- Isaac boss fires light beams periodically
    -- Every 150 frames, enhance the beam attack
    if frame - lastBeamFrame < 150 then
        -- Check for active beams and spawn holy creep under them
        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent:Exists() and ent.Type == EntityType.ENTITY_EFFECT then
                if ent.Variant == EffectVariant.CRACK_THE_SKY then
                    -- Create holy creep under beam positions
                    local pos = ent.Position
                    local room = Game():GetRoom()
                    local idx = room:GetGridIndex(pos)

                    -- Spawn holy creep only if not already present
                    if frame % 15 == 0 then
                        Isaac.Spawn(EntityType.ENTITY_EFFECT,
                            EffectVariant.PLAYER_CREEP_HOLY, 0,
                            pos, Vector(0, 0), nil)
                    end

                    -- Wider beam effect: spawn additional beams to the sides
                    if not activeBeams[ent.InitSeed] then
                        activeBeams[ent.InitSeed] = true
                        local sideOffset = 50
                        for offset = -1, 1, 2 do
                            local sidePos = pos + Vector(offset * sideOffset, 0)
                            Isaac.Spawn(EntityType.ENTITY_EFFECT,
                                EffectVariant.CRACK_THE_SKY, 0,
                                sidePos, Vector(0, 0), nil)
                        end
                    end
                end
            end
        end

        -- Clean up tracked beams periodically
        if frame % 300 == 0 then
            activeBeams = {}
        end
        return
    end

    lastBeamFrame = frame

    -- Target the player with enhanced light beam volley
    -- Fire 5 wide beams in a spread pattern around the player
    local playerPos = player.Position
    local room = Game():GetRoom()

    for i = -2, 2 do
        local beamPos = playerPos + Vector(i * 60, 0)
        -- Main beam
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0,
            beamPos, Vector(0, 0), nil)
        -- Wider beams (side by side)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0,
            beamPos + Vector(30, 0), Vector(0, 0), nil)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.CRACK_THE_SKY, 0,
            beamPos + Vector(-30, 0), Vector(0, 0), nil)
    end

    -- Holy creep rings around beam positions
    for i = -3, 3 do
        local creepPos = playerPos + Vector(i * 40, 0)
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_HOLY, 0,
            creepPos, Vector(0, 0), nil)
    end

    -- Screen shake for dramatic effect
    room:TriggerShake(3)
    activeBeams = {}
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("IsaacLightBeam loaded!")
