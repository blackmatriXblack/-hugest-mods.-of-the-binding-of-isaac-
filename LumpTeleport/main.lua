-- =============================================================================
--  LumpTeleport - The Binding of Isaac: Repentance
--  Lump enemies periodically teleport to random positions in the room
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LumpTeleport", 1)
local LUMP_TYPE = 216         -- EntityType.ENTITY_LUMP (Womb bone lump enemy)
local TELEPORT_INTERVAL = 120  -- Teleport every 4 seconds

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= LUMP_TYPE then return end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local frame = Game():GetFrameCount()
    local room = Game():GetRoom()
    local player = Isaac.GetPlayer(0)

    -- Initialize data
    if data.init == nil then
        data.init = true
        data.lastTeleport = frame + math.random(30, TELEPORT_INTERVAL)
        data.warningTime = 0
        npc:AddEntityFlags(EntityFlag.FLAG_BLUE)
    end

    -- Warning phase: flash briefly before teleporting
    if data.warningTime > 0 then
        data.warningTime = data.warningTime - 1
        npc.Visible = (data.warningTime % 10) < 5  -- Flicker effect
        if data.warningTime <= 0 then
            -- Execute teleport
            local randX = room:GetTopLeftPos().X + math.random(80, room:GetGridWidth() * 40 - 80)
            local randY = room:GetTopLeftPos().Y + math.random(80, room:GetGridHeight() * 40 - 80)
            local targetPos = Vector(randX, randY)
            targetPos = room:GetClampedPosition(targetPos, 30)

            -- Spawn teleport effects
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TELEPORT, 0,
                npc.Position, Vector.Zero, npc)
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.TELEPORT, 0,
                targetPos, Vector.Zero, npc)

            npc.Position = targetPos
            npc.Velocity = Vector.Zero
            data.lastTeleport = frame
            data.warningTime = 0
            npc.Visible = true
        end
        return
    end

    -- Check if it's time to start warning for teleport
    if player:Exists() and frame - data.lastTeleport >= TELEPORT_INTERVAL then
        -- 40% chance per check when cooldown is ready
        if math.random() < 0.1 then
            data.warningTime = 25  -- ~0.8 seconds of warning
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("LumpTeleport loaded!")
