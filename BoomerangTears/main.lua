-- =============================================================================
--  BoomerangTears - The Binding of Isaac: Repentance
--  Tears boomerang back toward the player after 200px, hitting enemies on return.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BoomerangTears", 1)

local tearData = {} -- maps tear pointer to { spawnPos, returning }
local BOOMERANG_DIST = 200

function mod:onTearUpdate(tear)
    if not tear.Visible then return end

    local ptr = GetPtrHash(tear)
    local data = tearData[ptr]

    if not data then
        tearData[ptr] = {
            spawnPos = tear.Position,
            returning = false,
        }
        data = tearData[ptr]
    end

    local dist = (tear.Position - data.spawnPos):Length()

    if not data.returning and dist >= BOOMERANG_DIST then
        data.returning = true
    end

    if data.returning then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        local dir = (player.Position - tear.Position):Normalized()
        local speed = tear.Velocity:Length()
        tear.Velocity = dir * speed * 1.4
        tear.Color = Color(1.0, 1.0, 0.3, 1.0, 0, 0, 0)

        -- Delete when close to player
        if (tear.Position - player.Position):Length() < 30 then
            tear:Die()
            tearData[ptr] = nil
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.onTearUpdate)
Isaac.DebugString("BoomerangTears loaded!")
