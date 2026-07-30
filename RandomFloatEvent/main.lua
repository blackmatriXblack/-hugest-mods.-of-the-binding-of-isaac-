-- 0.1% chance per frame to spawn a random item
local mod = RegisterMod("RandomFloatEvent", 1)
local game = Game()

function mod:onPostUpdate()
    local rng = RNG()
    if rng:RandomFloat() < 0.001 then
        local player = Isaac.GetPlayer(0)
        if player then
            local itemId = 29  -- The Poop, a common item
            Isaac.Spawn(5, 100, itemId, player.Position, Vector(0, 0), nil)
            Isaac.DebugString("RandomFloatEvent: Spawned random item!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onPostUpdate)
Isaac.DebugString("RandomFloatEvent loaded! 0.1% chance per frame to spawn an item.")
