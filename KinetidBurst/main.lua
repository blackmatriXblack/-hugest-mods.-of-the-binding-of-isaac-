-- ==========================================================================
--  KinetidBurst - The Binding of Isaac: Repentance
--  Kinetid bursts into 8 directional shots when killed.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("KinetidBurst", 1)
local ENEMY_KINETI = 286

local function onNPCDeath(_, npc)
    if npc.Type ~= ENEMY_KINETI then return end
    local pos = npc.Position
    local speed = 4
    local angles = {0, 45, 90, 135, 180, 225, 270, 315}
    for _, deg in ipairs(angles) do
        local rad = math.rad(deg)
        local dir = Vector(math.cos(rad), math.sin(rad))
        local vel = dir * speed
        local params = ProjectileParams()
        params.Variant = ProjectileVariant.PROJECTILE_BONE
        npc:FireProjectiles(pos, vel, 0, params)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, onNPCDeath)
Isaac.DebugString("KinetidBurst loaded!")