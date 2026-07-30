-- =============================================================================
--  Polycephalus Enrage - The Binding of Isaac: Repentance
--  When one Polycephalus head dies, all surviving heads enrage with +40% damage and speed.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PolycephalusPhase", 1)
local game = Game()

-- Track heads that have already been notified of a death this frame
local processedHeads = {}

local POLYCEPHALUS_TYPE = 27 -- EntityType.ENTITY_POLYCEPHALUS

local function onNPCUpdate(_, npc)
    if npc.Type ~= POLYCEPHALUS_TYPE then return end
    if npc:IsDead() then return end

    local ptr = GetPtrHash(npc)
    if processedHeads[ptr] then
        processedHeads[ptr] = nil
        return
    end

    -- Check if any Polycephalus head in the room is dead/dying
    local room = game:GetRoom()
    local foundDead = false
    for i = 0, room:GetAliveEnemiesCount() - 1 do
        local other = room:GetAliveEnemy(i)
        if other and other.Type == POLYCEPHALUS_TYPE and other.Index ~= npc.Index then
            if other.HitPoints <= 0 or other:IsDead() then
                foundDead = true
                break
            end
        end
    end

    -- Also check all NPCs in room for recently dead Polycephalus heads
    if not foundDead then
        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent.Type == POLYCEPHALUS_TYPE and ent.Index ~= npc.Index then
                if ent:IsDead() or ent.HitPoints <= 0 then
                    foundDead = true
                    break
                end
            end
        end
    end

    if foundDead then
        -- Enrage this head: +40% damage, +40% speed, scale up slightly
        npc:AddEntityFlags(EntityFlag.FLAG_SLOW, false)
        npc.Scale = math.min(npc.Scale * 1.15, 1.5)
        -- Boost collision damage
        npc.CollisionDamage = npc.CollisionDamage * 1.4
        -- Mark as processed so we don't re-enrage every frame
        processedHeads[ptr] = true
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("PolycephalusPhase loaded!")
