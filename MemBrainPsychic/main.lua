-- ==========================================================================
--  MemBrainPsychic - The Binding of Isaac: Repentance
--  MemBrain telepathically links to nearby enemies; killing MemBrain damages all linked.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("MemBrainPsychic", 1)
local ENEMY_MEMBRAIN = 281
local LINK_RADIUS = 200

-- Track linked enemies per MemBrain
local linkedEnemies = {}

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_MEMBRAIN then return end
    local data = npc:GetData()
    if not data.linked then
        data.linked = {}
        local room = Game():GetRoom()
        for i = 0, room:GetAliveEnemiesCount() - 1 do
            local other = room:GetAliveEnemy(i)
            if other and other.Index ~= npc.Index and other.Type ~= ENEMY_MEMBRAIN then
                local dist = other.Position:Distance(npc.Position)
                if dist < LINK_RADIUS then
                    table.insert(data.linked, other.Index)
                end
            end
        end
    end
end

local function onNPCDeath(_, npc)
    if npc.Type ~= ENEMY_MEMBRAIN then return end
    local data = npc:GetData()
    if data.linked then
        local room = Game():GetRoom()
        for _, idx in ipairs(data.linked) do
            local entity = Isaac.GetEntityByIndex(idx)
            if entity and entity:Exists() and entity:IsEnemy() then
                entity:ToNPC()
                entity:TakeDamage(entity.MaxHitPoints * 0.5, 0, EntityRef(npc), 0)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, onNPCDeath)
Isaac.DebugString("MemBrainPsychic loaded!")