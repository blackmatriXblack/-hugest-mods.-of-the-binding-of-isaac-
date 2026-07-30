-- =============================================================================
--  WizoobPhase - The Binding of Isaac: Repentance
--  Wizoob ghost periodically phases through walls and teleports near the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("WizoobPhase", 1)
local WIZOOB_TYPE = 223 -- EntityType.ENTITY_WIZOOB
local PHASE_INTERVAL = 150 -- 5 seconds

local function isPositionValid(pos)
    local room = Game():GetRoom()
    if not room then return false end
    return room:IsPositionInRoom(pos, 10)
end

local function onNPCUpdate(_, entity)
    if entity.Type ~= WIZOOB_TYPE or not entity:Exists() then
        return
    end

    if entity.I1 or 0 <= 0 then
        entity.I1 = PHASE_INTERVAL
    end

    entity.I1 = (entity.I1 or PHASE_INTERVAL) - 1

    if entity.I1 <= 0 and entity.I1 > -30 then
        entity.I1 = -60 -- prevent re-trigger
        -- Ghostly phase: make transparent and invulnerable briefly
        entity:AddEntityFlags(EntityFlag.FLAG_NO_KNOCKBACK)
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_NONE

        -- Teleport near player
        local player = Isaac.GetPlayer(0)
        if player and player:Exists() then
            local attempts = 0
            local found = false
            while attempts < 20 and not found do
                attempts = attempts + 1
                local randAngle = math.random() * math.pi * 2
                local randDist = math.random(40, 120)
                local targetPos = player.Position + Vector(math.cos(randAngle) * randDist, math.sin(randAngle) * randDist)

                if isPositionValid(targetPos) then
                    entity.Position = targetPos
                    found = true
                end
            end
        end
    elseif entity.I1 <= -30 then
        -- Restore collision
        entity.EntityCollisionClass = EntityCollisionClass.ENTCOLL_ALL
        entity.I1 = PHASE_INTERVAL
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("WizoobPhase loaded!")
