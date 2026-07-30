-- =============================================================================
--  HeadlessHorsemanChase — The Binding of Isaac: Repentance
--  Headless Horseman (Type=43.0) head chases player independently at 2x speed
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HeadlessHorsemanChase", 1)

local HORSEMAN_HEAD_TYPE = EntityType.ENTITY_HORSEMAN_HEAD -- Type 43 variant 0
local HORSEMAN_BODY_TYPE = EntityType.ENTITY_HORSEMAN
local CHASE_SPEED_MULT = 2.0
local DETACH_DISTANCE = 300

local chaseTargets = {}

function mod:onNPCUpdate(npc)
    if npc.Type ~= HORSEMAN_HEAD_TYPE and npc.Type ~= HORSEMAN_BODY_TYPE then
        return
    end

    -- Find Horseman head in the room
    local room = Game():GetRoom()
    for i = 0, room:GetAliveEnemiesCount() - 1 do
        local enemy = room:GetAliveEnemy(i)
        if enemy and enemy.Type == HORSEMAN_HEAD_TYPE then
            local headIdx = GetPtrHash(enemy)

            -- Get player target
            local nearestPlayer = nil
            local nearestDist = 99999
            for p = 0, Game():GetNumPlayers() - 1 do
                local player = Isaac.GetPlayer(p)
                if player and player:IsAlive() then
                    local dist = enemy.Position:Distance(player.Position)
                    if dist < nearestDist then
                        nearestDist = dist
                        nearestPlayer = player
                    end
                end
            end

            if nearestPlayer then
                -- Head chases player at 2x speed
                local dir = (nearestPlayer.Position - enemy.Position):Normalized()
                local targetSpeed = enemy.Velocity:Length() * CHASE_SPEED_MULT

                -- Apply chase velocity
                enemy.Velocity = dir * math.min(targetSpeed, 6.0)

                -- If close enough, deal contact damage or similar effect
                if nearestDist < 20 then
                    nearestPlayer:TakeDamage(0.5, DamageFlag.DAMAGE_NOKILL, EntityRef(enemy), 0)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNPCUpdate)
Isaac.DebugString("HeadlessHorsemanChase loaded!")
