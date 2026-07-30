-- =============================================================================
--  GusherPush - The Binding of Isaac: Repentance
--  Gusher pushes player away with a knockback wave every 6 seconds
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GusherPush", 1)
local GUSHER_TYPE = 285
local PUSH_INTERVAL = 180 -- 6 seconds * 30 fps
local PUSH_RADIUS = 150
local KNOCKBACK_STRENGTH = 8
local PUSH_DAMAGE = 0.5

function mod:OnNPCUpdate(npc)
    if npc.Type ~= GUSHER_TYPE then return end

    local player = Isaac.GetPlayer(0)

    local data = npc:GetData()
    data.pushTimer = (data.pushTimer or 0) + 1

    if data.pushTimer >= PUSH_INTERVAL then
        data.pushTimer = 0

        -- Push wave: create ring of effect particles
        for i = 0, 15 do
            local angle = (i / 16) * math.pi * 2
            local ringX = npc.Position.X + math.cos(angle) * 20
            local ringY = npc.Position.Y + math.sin(angle) * 20
            local particle = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF1, 0,
                Vector(ringX, ringY), Vector.Zero, npc)
        end

        -- Apply knockback to nearby player
        if player and player.Position:Distance(npc.Position) <= PUSH_RADIUS then
            local awayDir = (player.Position - npc.Position):Normalized()
            player.Velocity = awayDir * KNOCKBACK_STRENGTH

            -- Small damage from shockwave
            player:TakeDamage(PUSH_DAMAGE, DamageFlag.DAMAGE_KNOCKBACK, EntityRef(npc), 0)

            -- Apply short stun/slow
            player:AddSlowing(EntityRef(npc), 15, 0.3, 0)

            -- Screen shake for impact
            Game():ShakeScreen(3)
        end

        -- Also push nearby enemies and pickups
        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent and ent:Exists() and ent.Position:Distance(npc.Position) <= PUSH_RADIUS then
                if ent.Type ~= GUSHER_TYPE then
                    local awayVec = (ent.Position - npc.Position):Normalized()
                    ent.Velocity = awayVec * KNOCKBACK_STRENGTH * 0.6
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("GusherPush loaded!")
