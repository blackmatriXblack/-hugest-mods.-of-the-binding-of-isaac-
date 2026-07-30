-- =============================================================================
--  MegaMawFlame - The Binding of Isaac: Repentance
--  Mega Maw fires homing brimstone sweeps instead of fixed pattern
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MegaMawFlame", 1)
local MEGA_MAW_ID = 262
local lastFireFrame = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= MEGA_MAW_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local player = Isaac.GetPlayer(0)

    if not player or not player:Exists() then return end

    -- Fire homing brimstone sweep every 80 frames
    if frame - lastFireFrame >= 80 then
        lastFireFrame = frame

        -- Sweep a brimstone beam toward the player with slight homing curve
        local dirToPlayer = (player.Position - npc.Position):Normalized()

        -- Fire 3 brimstone beams in a fan pattern that homes slightly
        for offset = -15, 15, 15 do
            local angle = math.atan2(dirToPlayer.Y, dirToPlayer.X) + (offset * math.pi / 180)
            local dir = Vector(math.cos(angle), math.sin(angle))

            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                npc.Position, dir * 5, npc):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_BRIMSTONE)
                tear:AddTearFlags(TearFlags.TEAR_HOMING)
                tear.Scale = 2.0
                tear.FallingSpeed = 0.3 -- Slow homing curve
            end
        end

        -- Visual telegraph: red flash on Mega Maw
        npc:SetColor(Color(1, 0.3, 0.3, 1, 0, 0, 0), 5, 0, false, false)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("MegaMawFlame loaded!")
