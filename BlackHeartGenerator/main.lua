-- BlackHeartGenerator: Boss kills give 2 black hearts, regular enemies 10% chance for 1
local mod = RegisterMod("BlackHeartGenerator", 1)

function mod:onEntityKill(entity)
    local player = Isaac.GetPlayer(0)
    if entity:IsBoss() then
        player:AddBlackHearts(2)
        Isaac.DebugString("BlackHeartGenerator: Boss kill, added 2 black hearts!")
    elseif entity:IsEnemy() then
        local rng = RNG()
        rng:SetSeed(math.floor(os.time()), 0)
        if rng:RandomInt(100) < 10 then
            player:AddBlackHearts(1)
            Isaac.DebugString("BlackHeartGenerator: Enemy kill, added 1 black heart!")
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("BlackHeartGenerator loaded! Boss kills drop black hearts.")
