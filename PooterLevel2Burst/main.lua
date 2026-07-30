-- ==========================================================================
--  PooterLevel2Burst - The Binding of Isaac: Repentance
--  Level 2 Pooter fires 5 rapid shots in burst then pauses.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("PooterLevel2Burst", 1)
local ENEMY_POOTER = 14
local BURST_COOLDOWN = 150
local BURST_COUNT = 5
local BURST_DELAY = 4

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_POOTER or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.burstTimer then data.burstTimer = 0 end
    if not data.shotsLeft then data.shotsLeft = 0 end
    if not data.shotDelay then data.shotDelay = 0 end

    if data.shotsLeft > 0 then
        data.shotDelay = data.shotDelay + 1
        if data.shotDelay >= BURST_DELAY then
            data.shotDelay = 0
            data.shotsLeft = data.shotsLeft - 1
            local player = Isaac.GetPlayer(0)
            if player then
                local dir = (player.Position - npc.Position):Normalized()
                local params = ProjectileParams()
                params.Variant = ProjectileVariant.PROJECTILE_NORMAL
                params.Spread = math.random(-5, 5)
                npc:FireProjectiles(npc.Position + dir * 10, dir * 5, 0, params)
            end
        end
    else
        data.burstTimer = data.burstTimer + 1
        if data.burstTimer >= BURST_COOLDOWN then
            data.burstTimer = 0
            data.shotsLeft = BURST_COUNT
            data.shotDelay = 0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("PooterLevel2Burst loaded!")