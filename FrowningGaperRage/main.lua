-- =============================================================================
--  FrowningGaperRage — The Binding of Isaac: Repentance
--  Frowning Gapers (Type=4, Variant=1) gain speed and damage buff per dead enemy.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("FrowningGaperRage", 1)

local RAGE_RADIUS = 250
local SPEED_BONUS_PER_BODY = 0.3
local DAMAGE_BONUS_PER_BODY = 0.5

function mod:onUpdate()
    local entities = Isaac.GetRoomEntities()

    -- Count nearby dead enemies for each Frowning Gaper
    for _, gaper in ipairs(entities) do
        if gaper.Type ~= 4 or gaper.Variant ~= 1 then goto continue end
        if not gaper:IsVulnerableEnemy() then goto continue end

        local deadCount = 0
        for _, other in ipairs(entities) do
            if other ~= gaper and other:IsDead() then
                local dist = gaper.Position:Distance(other.Position)
                if dist < RAGE_RADIUS then
                    deadCount = deadCount + 1
                end
            end
        end

        if deadCount > 0 then
            -- Apply speed buff
            local scaleMult = 1 + deadCount * SPEED_BONUS_PER_BODY
            gaper.Scale = math.min(2.5, scaleMult)

            -- Boost velocity
            local currentSpeed = gaper.Velocity:Length()
            if currentSpeed > 0 then
                local dir = gaper.Velocity:Normalized()
                gaper.Velocity = dir * (currentSpeed + deadCount * 0.15)
            end
        end

        ::continue::
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("FrowningGaperRage loaded!")
