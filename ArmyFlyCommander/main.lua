-- =============================================================================
--  ArmyFlyCommander — The Binding of Isaac: Repentance
--  Army Flies (Type=45) buff nearby enemy speed by 30%.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ArmyFlyCommander", 1)

function mod:onUpdate()
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsActiveEnemy() and e.Type == 45 then
            local auraPos = e.Position
            local auraRadius = 120
            for _, other in ipairs(entities) do
                if other ~= e and other:IsActiveEnemy() then
                    local dist = (other.Position - auraPos):Length()
                    if dist <= auraRadius then
                        local pathfinder = other.Pathfinder
                        if pathfinder then
                            local baseSpeed = 1.3
                            local currentSpeed = pathfinder.MoveSpeed or 1.0
                            if currentSpeed < baseSpeed then
                                pathfinder.MoveSpeed = baseSpeed
                            end
                        end
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("ArmyFlyCommander loaded!")
