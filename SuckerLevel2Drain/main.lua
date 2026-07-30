-- ==========================================================================
--  SuckerLevel2Drain - The Binding of Isaac: Repentance
--  Level 2 Sucker drains 2 HP per second when attached, heals self.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SuckerLevel2Drain", 1)
local ENEMY_SUCKER = 61
local DRAIN_INTERVAL = 30
local DRAIN_AMOUNT = 1.0

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_SUCKER or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.drainTick then data.drainTick = 0 end
    if not data.attached then data.attached = false end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    -- Check if Sucker is attached to player (position check)
    local dist = player.Position:Distance(npc.Position)

    if dist < 15 then
        data.attached = true
        data.drainTick = data.drainTick + 1
        if data.drainTick >= DRAIN_INTERVAL then
            data.drainTick = 0
            -- Drain 2 HP from player, heal self for same amount
            player:TakeDamage(DRAIN_AMOUNT, DamageFlag.DAMAGE_NOKILL, EntityRef(npc), 0)
            npc.HitPoints = math.min(npc.HitPoints + DRAIN_AMOUNT * 2, npc.MaxHitPoints)
        end
    else
        data.attached = false
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("SuckerLevel2Drain loaded!")