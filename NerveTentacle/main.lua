-- ==========================================================================
--  NerveTentacle - The Binding of Isaac: Repentance
--  Nerve enemy extends tentacles toward player from distance.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("NerveTentacle", 1)
local ENEMY_NERVE = 262
local TENTACLE_INTERVAL = 90
local TENTACLE_RANGE = 200
local TENTACLE_LIFETIME = 60

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_NERVE then return end
    local data = npc:GetData()
    if not data.tentacleTimer then data.tentacleTimer = 0 end

    data.tentacleTimer = data.tentacleTimer + 1
    if data.tentacleTimer >= TENTACLE_INTERVAL then
        data.tentacleTimer = 0
        local player = Isaac.GetPlayer(0)
        if player then
            local dist = player.Position:Distance(npc.Position)
            if dist < TENTACLE_RANGE then
                local dir = (player.Position - npc.Position):Normalized()
                -- Spawn tentacle effect from nerve toward player
                for d = 0, math.floor(dist), 20 do
                    local spawnPos = npc.Position + dir * d
                    local tentacle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, spawnPos, Vector.Zero, npc)
                    if tentacle and tentacle.Exists() then
                        tentacle:ToEffect()
                        tentacle.Timeout = TENTACLE_LIFETIME
                    end
                end
                -- Damage player if close enough
                if dist < 30 then
                    player:TakeDamage(1.0, DamageFlag.DAMAGE_NOKILL, EntityRef(npc), 0)
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("NerveTentacle loaded!")