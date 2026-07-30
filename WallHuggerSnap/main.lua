-- =============================================================================
--  WallHuggerSnap - The Binding of Isaac: Repentance
--  Wall Huggers periodically snap off the wall and lunge at the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("WallHuggerSnap", 1)
local WALL_HUGGER_TYPE = 235  -- EntityType.ENTITY_WALL_HUGGER / wall creep variant
local SNAP_INTERVAL = 180     -- Snap every 6 seconds
local SNAP_SPEED = 10         -- Lunge speed

function mod:onNpcUpdate(_, npc)
    if npc.Type ~= WALL_HUGGER_TYPE then return end
    if npc:IsDead() then return end

    local data = npc:GetData()
    local frame = Game():GetFrameCount()
    local player = Isaac.GetPlayer(0)
    local room = Game():GetRoom()

    -- Initialize
    if data.init == nil then
        data.init = true
        data.lastSnap = frame + math.random(60, 180)
        data.isSnapping = false
        data.snapTimer = 0
        data.homePos = Vector(npc.Position.X, npc.Position.Y)
        npc:AddEntityFlags(EntityFlag.FLAG_CHASE)
    end

    -- Snap/lunge state
    if data.isSnapping then
        data.snapTimer = data.snapTimer - 1

        if data.snapTimer <= 0 or not player:Exists() then
            -- Snap complete, return to wall
            data.isSnapping = false
            data.lastSnap = frame
            -- Return to nearest wall position
            local nearWall = room:GetNearestWall(data.homePos)
            local target = room:GetWallClampedPosition(data.homePos, nearWall, 20)
            npc.Position = target
            npc.Velocity = Vector.Zero
        end
        return
    end

    -- Check if it's time to snap
    if player:Exists() and frame - data.lastSnap >= SNAP_INTERVAL then
        local distToPlayer = (player.Position - npc.Position):Length()
        if distToPlayer < 300 then  -- Only snap if player is within range
            data.isSnapping = true
            data.snapTimer = 40     -- Snap lasts ~1.3 seconds

            -- Launch toward player with high speed
            local dirToPlayer = (player.Position - npc.Position):Normalized()
            npc.Velocity = dirToPlayer * SNAP_SPEED
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("WallHuggerSnap loaded!")
