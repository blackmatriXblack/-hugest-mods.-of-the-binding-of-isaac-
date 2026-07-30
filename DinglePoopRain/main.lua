-- =============================================================================
--  DinglePoopRain - The Binding of Isaac: Repentance
--  Dingle boss - poops rain from the sky every 3 seconds during fight
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DinglePoopRain", 1)
local DINGLE_ID = 261
local POOP_ID = 14 -- GridEntity Poop

local nextRainFrame = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= DINGLE_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    if frame >= nextRainFrame and npc.HitPoints > 0 then
        nextRainFrame = frame + 90 -- 3 seconds at 30fps

        local room = Game():GetRoom()
        -- Spawn 5-8 random poops around the room
        local count = math.random(5, 8)
        for _ = 1, count do
            local x = room:GetCenterPos().X + math.random(-200, 200)
            local y = room:GetCenterPos().Y + math.random(-150, 150)
            local pos = Vector(x, y)
            -- Spawn a destructible poop grid entity
            Isaac.GridSpawn(GridEntityType.GRID_POOP, 0, room:GetGridIndex(pos), true)
        end

        -- Visual feedback: spawn poop particle effect
        local effect = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOP_PARTICLE, 0,
            room:GetCenterPos(), Vector(0, 0), nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("DinglePoopRain loaded!")
