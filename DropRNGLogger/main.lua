-- Log the drop seed when an entity is killed
local mod = RegisterMod("DropRNGLogger", 1)
local game = Game()

function mod:onEntityKill(entity)
    if entity then
        local dropRNG = entity:GetDropRNG()
        if dropRNG then
            local seed = dropRNG:GetSeed()
            Isaac.DebugString("Entity " .. entity.Type .. " killed. Drop seed: " .. tostring(seed))
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_ENTITY_KILL, mod.onEntityKill)
Isaac.DebugString("DropRNGLogger loaded! Logs drop seeds on entity kill.")
