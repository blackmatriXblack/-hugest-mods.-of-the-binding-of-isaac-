-- =============================================================================
--  HushLaserStorm - The Binding of Isaac: Repentance
--  Hush laser attack has 20% chance to be replaced by homing brimstone sweep
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HushLaserStorm", 1)
local HUSH_ID = 407
local lastAttackFrame = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= HUSH_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local player = Isaac.GetPlayer(0)
    if not player or not player:Exists() then return end

    -- Check Hush attack patterns every 120 frames
    if frame - lastAttackFrame < 120 then return end

    -- 20% chance to replace normal laser with homing brimstone sweep
    if math.random(1, 100) <= 20 then
        lastAttackFrame = frame

        -- Telegraph with red glow
        npc:SetColor(Color(1, 0.2, 0.2, 1, 0, 0, 0), 30, 0, false, false)

        -- Delay, then fire homing brimstone sweep
        -- We use a timer-based approach: start sweeping after brief delay
        local startAngle = math.atan2(player.Position.Y - npc.Position.Y,
            player.Position.X - npc.Position.X)

        -- Fire a spiral of homing brimstone tears
        for i = 0, 11 do
            local angle = startAngle + (i * math.pi / 6)
            local dir = Vector(math.cos(angle), math.sin(angle))
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                npc.Position, dir * 3, npc):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_BRIMSTONE)
                tear:AddTearFlags(TearFlags.TEAR_HOMING)
                tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                tear.Scale = 1.5
                -- Slow movement allows homing to take effect
                tear.FallingSpeed = 0.2
            end
        end

        -- Screen shake for impact
        Game():GetRoom():TriggerShake(5)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("HushLaserStorm loaded!")
