-- ==========================================================================
--  HorfLevel2Triple - The Binding of Isaac: Repentance
--  Level 2 Horf fires 3 shots in a burst instead of 1.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("HorfLevel2Triple", 1)
local ENEMY_HORF = 148
local BURST_COOLDOWN = 120
local BURST_DELAY = 5

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_HORF or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.burstTimer then data.burstTimer = 0 end
    if not data.burstCount then data.burstCount = 0 end
    if not data.burstDelay then data.burstDelay = 0 end

    if data.burstCount > 0 then
        data.burstDelay = data.burstDelay + 1
        if data.burstDelay >= BURST_DELAY then
            data.burstDelay = 0
            data.burstCount = data.burstCount - 1
            local player = Isaac.GetPlayer(0)
            if player then
                local dir = (player.Position - npc.Position):Normalized()
                local offset = npc.Position + dir * 20
                local vel = dir * 6
                local projParams = ProjectileParams()
                projParams.Variant = ProjectileVariant.PROJECTILE_NORMAL
                npc:FireProjectiles(offset, vel, 0, projParams)
            end
        end
    else
        data.burstTimer = data.burstTimer + 1
        if data.burstTimer >= BURST_COOLDOWN then
            data.burstTimer = 0
            data.burstCount = 3
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("HorfLevel2Triple loaded!")