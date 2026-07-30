-- =============================================================================
--  DarkOneTeleport - The Binding of Isaac: Repentance
--  Dark One teleports every 4 seconds and fires 8-way brimstone lasers briefly
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DarkOneTeleport", 1)
local DARK_ONE_ID = 267
local lastTeleportFrame = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= DARK_ONE_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local room = Game():GetRoom()

    -- Teleport every 120 frames (4 seconds)
    if frame - lastTeleportFrame >= 120 then
        lastTeleportFrame = frame

        -- Flash before teleporting
        npc:AddEntityFlags(EntityFlag.FLAG_ICE)

        -- Teleport to random position in the room
        local center = room:GetCenterPos()
        local teleX = center.X + math.random(-180, 180)
        local teleY = center.Y + math.random(-130, 130)

        -- Brief delay then teleport
        npc.Position = Vector(teleX, teleY)

        -- Fire 8-way brimstone lasers after teleport
        local angles = {0, 45, 90, 135, 180, 225, 270, 315}
        for _, deg in ipairs(angles) do
            local rad = deg * math.pi / 180
            local dir = Vector(math.cos(rad), math.sin(rad))
            local laser = Isaac.Spawn(EntityType.ENTITY_EFFECT,
                EffectVariant.CRACK_THE_SKY, 0,
                npc.Position, dir * 4, npc)
        end

        -- Also fire 8-way tears for guaranteed damage
        for _, deg in ipairs(angles) do
            local rad = deg * math.pi / 180
            local dir = Vector(math.cos(rad), math.sin(rad))
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                npc.Position, dir * 5, npc):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_BRIMSTONE)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("DarkOneTeleport loaded!")
