-- =============================================================================
--  FireTearSplitter — The Binding of Isaac: Repentance
--  Fired tears split into 2 smaller tears after traveling 200 units.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FireTearSplitter", 1)
local tearStartPositions = {}
local SPLIT_DISTANCE = 200

function mod:onFireTear(tear)
    tearStartPositions[GetPtrHash(tear)] = tear.Position
    Isaac.DebugString("FireTearSplitter: Tear fired, tracking position")
end

function mod:onTearUpdate(tear)
    local ptrHash = GetPtrHash(tear)
    local startPos = tearStartPositions[ptrHash]
    if not startPos then return end

    if tear.Position:Distance(startPos) >= SPLIT_DISTANCE then
        tearStartPositions[ptrHash] = nil
        local angle = tear.Velocity:GetAngleDegrees()
        -- Split into 2 smaller tears at ±15 degrees
        for _, offset in ipairs({-15, 15}) do
            local newAngle = angle + offset
            local newVel = Vector.FromAngleDegrees(newAngle) * tear.Velocity:Length()
            local newTear = Isaac.Spawn(EntityType.ENTITY_TEAR, TearVariant.BLUE, 0, tear.Position, newVel, tear.SpawnerEntity)
            if newTear then
                newTear:SetColor(Color(0.6, 0.8, 1, 1, 0, 0, 0), 0, 0)
                newTear.Scale = 0.6
            end
        end
        tear:Remove()
    end
end

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, mod.onFireTear)
mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, mod.onTearUpdate)
Isaac.DebugString("FireTearSplitter loaded!")
