local mod = RegisterMod("BloodColorOverride", 1)
local rng = RNG()

function mod:onEntitySpawn(entity)
    if entity:IsEnemy() then
        rng:SetSeed(entity.InitSeed, 3)
        local colors = {
            Color(1,0,0,1,0,0,0),   -- Red
            Color(0,1,0,1,0,0,0),   -- Green
            Color(0,0,1,1,0,0,0),   -- Blue
            Color(1,1,0,1,0,0,0),   -- Yellow
            Color(1,0,1,1,0,0,0),   -- Magenta
            Color(0,1,1,1,0,0,0),   -- Cyan
        }
        local idx = math.floor(rng:RandomFloat() * #colors) + 1
        entity:SetColor(colors[idx], 99999, 0, true, false)
    end
end

mod:AddCallback(13, mod.onEntitySpawn) -- MC_POST_ENTITY_SPAWN
Isaac.DebugString("BloodColorOverride: Random blood color for each enemy!")
