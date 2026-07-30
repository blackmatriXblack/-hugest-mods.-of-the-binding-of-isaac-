-- =============================================================================
--  SpiderWebTrap — The Binding of Isaac: Repentance
--  Spiders (Type=42) slow player by 40% when within 50 distance.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("SpiderWebTrap", 1)

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if not player then return end

    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsActiveEnemy() and e.Type == 42 then
            local dist = (e.Position - player.Position):Length()
            if dist <= 50 then
                player:AddSlowing(EntityRef(e), 1, 0, Color.Default)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("SpiderWebTrap loaded!")
