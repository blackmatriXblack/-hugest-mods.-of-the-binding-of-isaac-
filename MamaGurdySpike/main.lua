-- =============================================================================
--  Mama Gurdy Spike Volley - The Binding of Isaac: Repentance
--  Mama Gurdy's spike attacks also fire 2 blood shots toward the player.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MamaGurdySpike", 1)

local MAMA_GURDY_TYPE = 84 -- EntityType.ENTITY_MAMA_GURDY

local function onNPCUpdate(_, npc)
    if npc.Type ~= MAMA_GURDY_TYPE then return end
    if npc:IsDead() then return end

    -- During spike attack state, fire blood shots at player
    if npc.State == NpcState.STATE_ATTACK2 then
        local player = Isaac.GetPlayer(0)
        if player then
            local toPlayer = (player.Position - npc.Position):Normalized()
            for i = -1, 1, 2 do
                local angle = math.rad(math.deg(math.atan2(toPlayer.Y, toPlayer.X)) + i * 15)
                local vel = Vector(math.cos(angle), math.sin(angle)) * 4.5
                local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0,
                    npc.Position, vel, npc)
                if tear then
                    local t = tear:ToProjectile()
                    if t then
                        t:AddProjectileFlags(ProjectileFlags.BLOOD, true)
                        t.Scale = 0.8
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("MamaGurdySpike loaded!")
