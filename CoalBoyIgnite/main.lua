-- =============================================================================
--  CoalBoyIgnite - The Binding of Isaac: Repentance
--  Coal Boy ignites after 5 seconds leaving fire creep everywhere
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("CoalBoyIgnite", 1)
local COAL_BOY_TYPE = 281
local IGNITE_TIME = 150 -- 5 seconds * 30 fps
local FIRE_CREEP_VARIANT = 1 -- variant 1 = fire creep
local FIRE_INTERVAL = 5 -- frames between fire spawns

function mod:OnNPCUpdate(npc)
    if npc.Type ~= COAL_BOY_TYPE then return end

    local data = npc:GetData()
    data.lifeTimer = (data.lifeTimer or 0) + 1

    -- Pre-ignition: flicker and glow red
    if data.lifeTimer >= IGNITE_TIME * 0.8 then
        local flicker = math.sin(data.lifeTimer * 0.5) * 0.3 + 0.7
        npc.Color = Color(flicker, flicker * 0.3, flicker * 0.1, 1, 0, 0, 0)
    end

    -- Ignition!
    if data.lifeTimer >= IGNITE_TIME and not data.ignited then
        data.ignited = true
        data.fireTick = 0
        -- Visual burst
        Game():BombExplosionEffects(npc.Position, 0)
    end

    -- After ignition: spread fire everywhere
    if data.ignited then
        data.fireTick = (data.fireTick or 0) + 1
        if data.fireTick >= FIRE_INTERVAL then
            data.fireTick = 0
            -- Spawn fire creep at random nearby positions
            for i = 1, 3 do
                local offX = math.random(-50, 50)
                local offY = math.random(-50, 50)
                local spawnPos = npc.Position + Vector(offX, offY)
                Isaac.GridSpawn(GridEntityType.GRID_CREEP, FIRE_CREEP_VARIANT, spawnPos, true)
            end
        end

        -- Coal Boy takes fire damage itself while ignited
        if data.lifeTimer % 15 == 0 then
            npc:TakeDamage(0.5, 0, EntityRef(npc), 0)
        end

        -- Flash red
        npc:AddEntityFlags(EntityFlag.FLAG_BURN)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("CoalBoyIgnite loaded!")
