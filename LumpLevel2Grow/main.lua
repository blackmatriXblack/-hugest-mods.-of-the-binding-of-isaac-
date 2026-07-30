-- ==========================================================================
--  LumpLevel2Grow - The Binding of Isaac: Repentance
--  Level 2 Lump grows in size over time (caps at 3x) gaining HP proportional to size.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("LumpLevel2Grow", 1)
local ENEMY_LUMP = 283
local GROWTH_SCALE = 0.003
local MAX_SCALE = 3.0
local GROWTH_INTERVAL = 60

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_LUMP or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.initialized then
        data.initialized = true
        data.growthTimer = 0
        data.currentScale = 1.0
        data.baseMaxHP = npc.MaxHitPoints
    end
    data.growthTimer = data.growthTimer + 1
    if data.growthTimer >= GROWTH_INTERVAL and data.currentScale < MAX_SCALE then
        data.growthTimer = 0
        data.currentScale = math.min(data.currentScale + 0.05, MAX_SCALE)
        npc.SpriteScale = Vector(data.currentScale, data.currentScale)
        -- HP scales proportionally with size
        local newMaxHP = data.baseMaxHP * data.currentScale
        local hpDiff = newMaxHP - npc.MaxHitPoints
        npc.MaxHitPoints = newMaxHP
        npc.HitPoints = npc.HitPoints + hpDiff
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("LumpLevel2Grow loaded!")