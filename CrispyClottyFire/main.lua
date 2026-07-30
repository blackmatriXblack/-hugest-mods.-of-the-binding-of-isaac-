-- =============================================================================
--  CrispyClottyFire - The Binding of Isaac: Repentance
--  Burnt/charred Clotty variant leaves fire trail and is immune to fire damage
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CrispyClottyFire", 1)
local CLOTTY_TYPE = 219        -- EntityType.ENTITY_CLOTTY
local CRISPY_VARIANT = 1       -- Burnt/charred variant (custom)
local FIRE_TRAIL_INTERVAL = 8   -- Frames between fire placements

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= CLOTTY_TYPE or npc.Variant ~= CRISPY_VARIANT then return end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local frame = Game():GetFrameCount()

    -- Initialize
    if data.init == nil then
        data.init = true
        data.lastFire = frame
        -- Fire immunity: add fire-related flags
        npc:AddEntityFlags(EntityFlag.FLAG_FIRE)
        npc:AddEntityFlags(EntityFlag.FLAG_BURN)
    end

    -- Leave fire trail when moving
    if npc.Velocity:Length() > 1 and frame - data.lastFire >= FIRE_TRAIL_INTERVAL then
        data.lastFire = frame
        local firePos = npc.Position + Vector(math.random(-15, 15), math.random(-15, 15))
        local fire = Isaac.Spawn(EntityType.ENTITY_EFFECT,
            EffectVariant.FIRE_PLACE, 0,
            firePos, Vector.Zero, npc)
        if fire then
            fire.SpriteScale = Vector(0.7, 0.7)
            -- Short-lived fire trail (despawns after ~3 seconds)
            fire:GetData().despawnTime = 90
        end
    end

    -- Clean up old fire effects
    local ents = Isaac.GetRoomEntities()
    for _, ent in ipairs(ents) do
        if ent.Type == EntityType.ENTITY_EFFECT and
           ent.Variant == EffectVariant.FIRE_PLACE then
            local fdata = ent:GetData()
            if fdata.despawnTime then
                fdata.despawnTime = fdata.despawnTime - 1
                if fdata.despawnTime <= 0 then
                    ent:Remove()
                end
            end
        end
    end

    -- Fire aura: damage nearby entities
    if frame % 15 == 0 then  -- Check 4 times per second
        local ents2 = Isaac.GetRoomEntities()
        for _, ent in ipairs(ents2) do
            if ent.Type ~= CLOTTY_TYPE and ent:IsVulnerableEnemy() then
                local dist = (ent.Position - npc.Position):Length()
                if dist <= 40 then
                    ent:TakeDamage(3, DamageFlag.DAMAGE_FIRE,
                        EntityRef(npc), 0)
                end
            end
        end

        -- Damage player if too close
        local player = Isaac.GetPlayer(0)
        if player:Exists() then
            local dist = (player.Position - npc.Position):Length()
            if dist <= 35 then
                player:TakeDamage(1, DamageFlag.DAMAGE_FIRE,
                    EntityRef(npc), 0)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("CrispyClottyFire loaded!")
