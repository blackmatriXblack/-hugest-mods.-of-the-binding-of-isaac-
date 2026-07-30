-- ==========================================================================
--  SmallLeechLevel2Chain - The Binding of Isaac: Repentance
--  Level 2 Small Leech chains between player and itself draining HP over time.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SmallLeechLevel2Chain", 1)
local ENEMY_SMALL_LEECH = 49
local CHAIN_RANGE = 150
local DRAIN_INTERVAL = 30
local DRAIN_AMOUNT = 0.5

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_SMALL_LEECH or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.drainTick then data.drainTick = 0 end
    if not data.isChained then data.isChained = false end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local dist = player.Position:Distance(npc.Position)

    if data.isChained then
        if dist > CHAIN_RANGE then
            data.isChained = false
            return
        end
        data.drainTick = data.drainTick + 1
        if data.drainTick >= DRAIN_INTERVAL then
            data.drainTick = 0
            player:TakeDamage(DRAIN_AMOUNT, DamageFlag.DAMAGE_NOKILL, EntityRef(npc), 0)
            npc.HitPoints = math.min(npc.HitPoints + DRAIN_AMOUNT * 2, npc.MaxHitPoints)
        end
    else
        if dist < 50 then
            data.isChained = true
            data.drainTick = 0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("SmallLeechLevel2Chain loaded!")