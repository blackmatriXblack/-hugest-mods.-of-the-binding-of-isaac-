-- =============================================================================
--  PaleGaperClone - The Binding of Isaac: Repentance
--  Pale Gaper spawns a ghostly half-HP clone of itself every 15 seconds
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PaleGaperClone", 1)
local PALE_TYPE = 5
local PALE_VARIANT = 11
local CLONE_INTERVAL = 450 -- 15 seconds * 30 fps

function mod:OnNPCUpdate(npc)
    if npc.Type ~= PALE_TYPE or npc.Variant ~= PALE_VARIANT then return end

    local data = npc:GetData()
    data.cloneTimer = (data.cloneTimer or 0) + 1

    if data.cloneTimer >= CLONE_INTERVAL then
        data.cloneTimer = 0

        -- Spawn ghostly clone with half HP
        local offset = Vector(math.random(-60, 60), math.random(-60, 60))
        local spawnPos = npc.Position + offset
        local clone = Isaac.Spawn(EntityType.ENTITY_GAPER, PALE_VARIANT, 0, spawnPos, Vector.Zero, npc)
        if clone then
            local halfHP = math.max(1, npc.MaxHitPoints / 2)
            clone.HitPoints = halfHP
            clone.MaxHitPoints = halfHP
            -- Ghost visual: make clone translucent
            clone:AddEntityFlags(EntityFlag.FLAG_GHOST | EntityFlag.FLAG_NO_TARGET)
            clone.Color = Color(1, 1, 1, 0.5, 0, 0, 0)
            -- Clone chases the player
            local player = Isaac.GetPlayer(0)
            if player then
                clone:Pathfind(player.Position, 0.6, 0)
            end
            clone:ClearEntityFlags(EntityFlag.FLAG_NO_TARGET)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("PaleGaperClone loaded!")
