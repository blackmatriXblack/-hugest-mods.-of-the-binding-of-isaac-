-- =============================================================================
--  MAGNETIC PICKUPS — The Binding of Isaac: Repentance
--  All pickups, hearts, coins, bombs, keys fly toward you.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("MagneticPickups", 1)

function mod:onUpdate()
    local player = Isaac.GetPlayer(0)
    if player == nil then return end
    local ppos = player.Position
    local entities = Isaac.GetRoomEntities()

    for i = 0, #entities - 1 do
        local e = entities:Get(i)
        if e ~= nil and e:Exists() then
            local etype = e.Type
            -- Pickups: hearts(10), coins(20), keys(30), bombs(40), cards(300), pills(70), trinkets(350), chests(360), sacks(69)
            if etype == 10 or etype == 20 or etype == 30 or etype == 40 or
               etype == 300 or etype == 70 or etype == 350 or etype == 360 or etype == 69 then
                local dist = ppos:Distance(e.Position)
                if dist < 400 and dist > 5 then
                    local dir = (ppos - e.Position):Normalized()
                    local speed = math.min(15, 500 / dist)
                    e.Velocity = dir * speed
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
Isaac.DebugString("Magnetic Pickups loaded! All pickups fly to you.")
