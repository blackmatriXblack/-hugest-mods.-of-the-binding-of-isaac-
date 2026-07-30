-- ==========================================================================
--  RaglingMerge - The Binding of Isaac: Repentance
--  When 3 Raglings are near each other, they merge into a stronger enemy.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RaglingMerge", 1)
local ENEMY_RAGLING = 246
local MERGE_RADIUS = 60
local MERGED_ENEMY = EntityType.ENTITY_RAG_MEGA

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_RAGLING then return end
    local data = npc:GetData()
    if not data.mergeChecked then data.mergeChecked = 0 end

    data.mergeChecked = data.mergeChecked + 1
    if data.mergeChecked % 30 ~= 0 then return end

    -- Find nearby Raglings
    local room = Game():GetRoom()
    local nearbyRaglings = {}
    for i = 0, room:GetAliveEnemiesCount() - 1 do
        local other = room:GetAliveEnemy(i)
        if other and other.Type == ENEMY_RAGLING and other.Index ~= npc.Index then
            local dist = other.Position:Distance(npc.Position)
            if dist < MERGE_RADIUS then
                table.insert(nearbyRaglings, other)
            end
        end
    end

    if #nearbyRaglings >= 2 then
        -- Merge 2 nearest raglings + self into Rag Mega
        local mergePos = npc.Position + nearbyRaglings[1].Position + nearbyRaglings[2].Position
        mergePos = mergePos / 3
        local megaEnemy = Isaac.Spawn(MERGED_ENEMY, 0, 0, mergePos, Vector.Zero, npc)
        if megaEnemy then
            megaEnemy:ToNPC()
            megaEnemy.HitPoints = npc.HitPoints + nearbyRaglings[1].HitPoints + nearbyRaglings[2].HitPoints
            megaEnemy.MaxHitPoints = megaEnemy.HitPoints
        end
        -- Remove the merged raglings
        nearbyRaglings[1]:Die()
        nearbyRaglings[2]:Die()
        npc:Die()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("RaglingMerge loaded!")