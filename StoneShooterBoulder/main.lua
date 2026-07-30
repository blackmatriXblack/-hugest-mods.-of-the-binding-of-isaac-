-- ==========================================================================
--  StoneShooterBoulder - The Binding of Isaac: Repentance
--  Stone Shooter fires boulders that roll across the room damaging everything.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("StoneShooterBoulder", 1)
local ENEMY_STONE_SHOOTER = 202
local BOULDER_INTERVAL = 180
local BOULDER_SPEED = 3
local BOULDER_DAMAGE = 2.0
local BOULDER_LIFETIME = 120

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_STONE_SHOOTER then return end
    local data = npc:GetData()
    if not data.boulderTimer then data.boulderTimer = 0 end

    data.boulderTimer = data.boulderTimer + 1
    if data.boulderTimer >= BOULDER_INTERVAL then
        data.boulderTimer = 0
        local player = Isaac.GetPlayer(0)
        if player then
            local dir = (player.Position - npc.Position):Normalized()
            -- Roll boulder in 3 directions
            for angle = -20, 20, 20 do
                local rad = math.rad(angle)
                local shootDir = Vector(
                    dir.X * math.cos(rad) - dir.Y * math.sin(rad),
                    dir.X * math.sin(rad) + dir.Y * math.cos(rad)
                )
                local boulder = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.ROCK_PARTICLE, 0, npc.Position + shootDir * 20, shootDir * BOULDER_SPEED, npc)
                if boulder and boulder.Exists() then
                    boulder:ToEffect()
                    boulder.Timeout = BOULDER_LIFETIME
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("StoneShooterBoulder loaded!")