-- =============================================================================
--  RingFlyCircle - The Binding of Isaac: Repentance
--  Ring Fly creates a circular damaging aura that grows over time then resets
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("RingFlyCircle", 1)
local RING_FLY_TYPE = 22 -- EntityType.ENTITY_RINGFLY
local GROW_RATE = 0.5 -- pixels per frame
local MAX_RADIUS = 120
local DAMAGE = 1.0
local auraData = {} -- entity index -> {currentRadius}

local function onNPCUpdate(_, entity)
    if entity.Type ~= RING_FLY_TYPE or not entity:Exists() then
        return
    end

    local idx = entity.Index
    if not auraData[idx] then
        auraData[idx] = {currentRadius = 10}
    end

    local data = auraData[idx]
    data.currentRadius = data.currentRadius + GROW_RATE

    if data.currentRadius >= MAX_RADIUS then
        data.currentRadius = 10 -- reset
    end

    -- Damage players within the aura radius
    local myPos = entity.Position
    for p = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        if player and player:Exists() then
            local dist = myPos:Distance(player.Position)
            if dist <= data.currentRadius and dist > 0 then
                -- Apply damage on contact with expanding ring edge
                if dist > data.currentRadius - 5 then
                    player:TakeDamage(DAMAGE, DamageFlag.DAMAGE_NOKILL, EntityRef(entity), 0)
                end
            end
        end
    end

    -- Visual feedback: move in a tight circle
    local angle = Game():GetFrameCount() * 0.05
    local orbitCenter = entity:GetDropRNG():NextFloat() < 0.5 and 1 or -1
    entity.Velocity = Vector(math.cos(angle) * 20 * orbitCenter, math.sin(angle) * 20 * orbitCenter) * 0.4
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("RingFlyCircle loaded!")
