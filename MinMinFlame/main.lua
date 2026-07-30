-- =============================================================================
--  Min-Min Flame - The Binding of Isaac: Repentance
--  Min-Min's fire attacks leave permanent small fires around the room (up to 12)
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MinMinFlame", 1)
local MIN_MIN_TYPE = 903 -- EntityType.ENTITY_MIN_MIN

function mod:onNPCUpdate(npc)
    if npc.Type ~= MIN_MIN_TYPE then return end
    
    -- Count existing fires in the room
    local fireCount = 0
    local roomEntities = Isaac.GetRoomEntities()
    for _, ent in ipairs(roomEntities) do
        if ent.Type == EntityType.ENTITY_EFFECT and ent.Variant == EffectVariant.HOT_BOMB_FIRE then
            fireCount = fireCount + 1
        end
    end
    
    -- Every 90 frames, try to place a new fire if under the limit
    if npc.FrameCount % 90 == 0 and fireCount < 12 then
        local spawnX = math.random(80, 560)
        local spawnY = math.random(80, 360)
        local spawnPos = Vector(spawnX, spawnY)
        
        local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, spawnPos, Vector.Zero, nil)
        if fire then
            fire:ToEffect().Timeout = -1 -- Permanent until room clear
            fire:ToEffect().Scale = 0.6
        end
    end
    
    -- When Min-Min does her fire attack (state 8), also drop fire at her position
    if npc.State == 8 and npc.StateFrame == 1 and fireCount < 12 then
        Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0, npc.Position, Vector.Zero, nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate, MIN_MIN_TYPE)
Isaac.DebugString("MinMinFlame loaded!")
