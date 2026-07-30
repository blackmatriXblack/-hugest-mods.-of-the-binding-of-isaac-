-- =============================================================================
--  Mega Clotty Merge - The Binding of Isaac: Repentance
--  Two Clotties within close range merge into a bigger, tougher Mega Clotty.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MegaClottyMerge", 1)

local CLOTTY_TYPE = 57      -- EntityType.ENTITY_CLOTTY
local MERGE_RADIUS = 30     -- Distance to trigger merge
local processedMerges = {}

local function onNPCUpdate(_, npc)
    if npc.Type ~= CLOTTY_TYPE then return end
    if npc:IsDead() then return end
    if npc.Scale >= 1.3 then return end -- Already merged, skip

    local ptr = GetPtrHash(npc)
    if processedMerges[ptr] then
        processedMerges[ptr] = nil
        return
    end

    -- Find nearby Clotties for merging
    local entities = Isaac.GetRoomEntities()
    for _, other in ipairs(entities) do
        if other.Type == CLOTTY_TYPE and other.Index ~= npc.Index
            and not other:IsDead() and other.Scale < 1.3
            and not processedMerges[GetPtrHash(other)] then

            local dist = (npc.Position - other.Position):Length()
            if dist <= MERGE_RADIUS then
                -- Merge: create bigger Clotty at midpoint
                local midPos = (npc.Position + other.Position) * 0.5
                local megaVariant = 2 -- Larger Clotty variant (if available)
                
                -- Wait, let's determine the merged size
                -- We'll kill both and spawn a bigger one
                processedMerges[ptr] = true
                processedMerges[GetPtrHash(other)] = true

                local mega = Isaac.Spawn(CLOTTY_TYPE, megaVariant, 0,
                    midPos, Vector.Zero, nil)
                if mega then
                    mega.HitPoints = npc.MaxHitPoints + other.MaxHitPoints
                    mega.Scale = 1.4
                    mega.CollisionDamage = npc.CollisionDamage * 1.8
                end

                -- Remove the original two
                npc:Kill()
                other:Kill()
                return
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("MegaClottyMerge loaded!")
