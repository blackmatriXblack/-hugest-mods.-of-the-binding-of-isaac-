-- =============================================================================
--  BlurbDivide - The Binding of Isaac: Repentance
--  Blurb divides into 2 smaller blurbs at 50% HP
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BlurbDivide", 1)
local BLURB_TYPE = 264
local SPLIT_HP_THRESHOLD = 0.5
local CHILD_SCALE = 0.7

function mod:OnTakeDamage(npc, amount, flags, source, countdown)
    if npc.Type ~= BLURB_TYPE then return end

    local data = npc:GetData()
    if data.hasSplit then return end

    local hpPct = npc.HitPoints / npc.MaxHitPoints

    if hpPct <= SPLIT_HP_THRESHOLD and not data.hasSplit then
        data.hasSplit = true

        -- Spawn 2 smaller Blurb children
        for i = 1, 2 do
            local angle = (i - 1) * math.pi + math.random() * 0.5
            local offX = math.cos(angle) * 30
            local offY = math.sin(angle) * 30
            local spawnPos = npc.Position + Vector(offX, offY)
            local child = Isaac.Spawn(EntityType.ENTITY_BLURB, 0, 0, spawnPos, Vector.Zero, npc)
            if child then
                -- Make child smaller with reduced HP
                local childMax = math.max(2, npc.MaxHitPoints * CHILD_SCALE)
                child.MaxHitPoints = childMax
                child.HitPoints = childMax
                child.Scale = CHILD_SCALE
                -- Mark child so it won't split again
                child:GetData().hasSplit = true
                -- Small burst velocity away from parent
                child.Velocity = Vector(math.cos(angle), math.sin(angle)) * 2
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, mod.OnTakeDamage)
Isaac.DebugString("BlurbDivide loaded!")
