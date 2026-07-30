-- =============================================================================
--  Faceless Mirror Shot - The Binding of Isaac: Repentance
--  Faceless copies the player's last fired tear direction and fires it back.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FacelessCopy", 1)

local FACELESS_TYPE = 802   -- Faceless entity (Repentance)
local MIRROR_INTERVAL = 45  -- Frames between mirror shots
local TEAR_SPEED = 3.5

local lastPlayerDir = Vector(0, -1)  -- Default upward
local lastMirrorFrame = {}

local function onPlayerFire(_, tear)
    -- Track the player's last tear direction
    if tear and tear.Position and tear.Velocity then
        local vel = tear.Velocity
        if vel:Length() > 0.1 then
            lastPlayerDir = vel:Normalized()
        end
    end
end

local function onNPCUpdate(_, npc)
    if npc.Type ~= FACELESS_TYPE then return end
    if npc:IsDead() then
        lastMirrorFrame[GetPtrHash(npc)] = nil
        return
    end

    local ptr = GetPtrHash(npc)
    local currentFrame = Game():GetFrameCount()

    if npc.State == NpcState.STATE_ATTACK then
        if not lastMirrorFrame[ptr] or currentFrame - lastMirrorFrame[ptr] >= MIRROR_INTERVAL then
            lastMirrorFrame[ptr] = currentFrame

            -- Fire a tear back toward the player direction
            local toPlayer = (Isaac.GetPlayer(0).Position - npc.Position):Normalized()
            local fireDir = lastPlayerDir

            -- If player is behind Faceless, flip direction
            local facingDot = fireDir.X * toPlayer.X + fireDir.Y * toPlayer.Y
            if facingDot < 0 then
                fireDir = toPlayer
            end

            local vel = fireDir * TEAR_SPEED
            local tear = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0,
                npc.Position, vel, npc)
            if tear then
                local t = tear:ToProjectile()
                if t then
                    t.Scale = 0.9
                    t.Color = Color(0.7, 0.7, 1.0, 1.0, 0, 0, 0) -- Mirror-blue tint
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, onPlayerFire)
mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("FacelessCopy loaded!")
