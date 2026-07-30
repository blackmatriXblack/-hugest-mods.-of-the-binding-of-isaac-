-- =============================================================================
--  KnifeSplitSpawn - The Binding of Isaac: Repentance
--  Knife spawns 3 small tears every 0.5 seconds while flying.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("KnifeSplitSpawn", 1)

local TEAR_INTERVAL = 15

function mod:onKnifeUpdate(knife)
    if not knife.Visible then return end
    if not knife:IsFlying() then return end

    if knife.FrameCount % TEAR_INTERVAL == 0 then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        for i = -1, 1 do
            local angle = math.rad(i * 30)
            local dir = Vector(math.cos(angle), math.sin(angle))
            local t = player:FireTear(knife.Position, dir * 4, false, false, false)
            t.Scale = 0.4
            t.Color = Color(1.0, 0.2, 0.2, 1.0, 0, 0, 0)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_KNIFE_UPDATE, mod.onKnifeUpdate)
Isaac.DebugString("KnifeSplitSpawn loaded!")
