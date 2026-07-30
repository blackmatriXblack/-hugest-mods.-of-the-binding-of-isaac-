-- ==========================================================================
--  HopperLeap - The Binding of Isaac: Repentance
--  Hopper leaps toward player every 3 seconds, dealing AOE on landing.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("HopperLeap", 1)
local ENEMY_HOPPER = 7
local LEAP_INTERVAL = 90
local AOE_RADIUS = 80
local AOE_DAMAGE = 2.0

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_HOPPER then return end
    local data = npc:GetData()
    if not data.leapTimer then data.leapTimer = LEAP_INTERVAL end
    if not data.isLeaping then data.isLeaping = false end

    if data.isLeaping then
        if npc.Velocity:Length() < 0.5 then
            data.isLeaping = false
            data.leapTimer = 0
            -- AOE damage on landing
            local player = Isaac.GetPlayer(0)
            if player and player.Position:Distance(npc.Position) < AOE_RADIUS then
                player:TakeDamage(AOE_DAMAGE, DamageFlag.DAMAGE_NOKILL, EntityRef(npc), 0)
            end
            -- Damage nearby enemies too
            local room = Game():GetRoom()
            for i = 0, room:GetAliveEnemiesCount() - 1 do
                local other = room:GetAliveEnemy(i)
                if other and other.Index ~= npc.Index then
                    local dist = other.Position:Distance(npc.Position)
                    if dist < AOE_RADIUS then
                        other:TakeDamage(AOE_DAMAGE * other.MaxHitPoints * 0.3, 0, EntityRef(npc), 0)
                    end
                end
            end
        end
    else
        data.leapTimer = data.leapTimer + 1
        if data.leapTimer >= LEAP_INTERVAL then
            local player = Isaac.GetPlayer(0)
            if player then
                local dir = (player.Position - npc.Position):Normalized()
                npc.Velocity = dir * 12
                data.isLeaping = true
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("HopperLeap loaded!")
