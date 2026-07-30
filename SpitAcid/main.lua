-- ==========================================================================
--  SpitAcid - The Binding of Isaac: Repentance
--  Spit enemy spits acid pools that linger for 10 seconds.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("SpitAcid", 1)
local ENEMY_SPIT = 275
local ACID_INTERVAL = 120
local ACID_LIFETIME = 300
local ACID_POOLS = 3

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_SPIT then return end
    local data = npc:GetData()
    if not data.acidTimer then data.acidTimer = 0 end

    data.acidTimer = data.acidTimer + 1
    if data.acidTimer >= ACID_INTERVAL then
        data.acidTimer = 0
        local player = Isaac.GetPlayer(0)
        if player then
            local baseDir = (player.Position - npc.Position):Normalized()
            for i = 1, ACID_POOLS do
                local spreadAngle = (i - 2) * 15
                local rad = math.rad(spreadAngle)
                local dir = Vector(
                    baseDir.X * math.cos(rad) - baseDir.Y * math.sin(rad),
                    baseDir.X * math.sin(rad) + baseDir.Y * math.cos(rad)
                )
                local spawnPos = npc.Position + dir * 60
                local acid = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.PLAYER_CREEP_RED, 0, spawnPos, Vector.Zero, npc)
                if acid and acid.Exists() then
                    acid:ToEffect()
                    acid.Timeout = ACID_LIFETIME
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("SpitAcid loaded!")