-- ==========================================================================
--  TearMines - The Binding of Isaac: Repentance
--  Tears stick to floor and walls as proximity mines that explode after 5 seconds!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TearMines", 1)
local MINES = {}
local STICK_CHANCE = 0.15

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    local id = tear.InitSeed
    local vel = tear.Velocity
    local speed = vel:Length()
    if speed < 1 and speed > 0 and math.random() < STICK_CHANCE and not MINES[id] then
        tear.Velocity = Vector.Zero
        MINES[id] = {pos = tear.Position, timer = 300, armed = false}
        tear:SetColor(Color(1, 0.2, 0.2, 1, 0, 0, 0), 0, 1)
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, function()
    local toExplode = {}
    for id, mine in pairs(MINES) do
        mine.timer = mine.timer - 1
        if mine.timer <= 60 and not mine.armed then
            mine.armed = true
        end
        if mine.armed and mine.timer % 6 == 0 then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SHOCKWAVE, 0,
                mine.pos, Vector.Zero, nil):SetTimeout(15)
        end
        if mine.timer <= 0 then
            table.insert(toExplode, id)
        end

        for e in pairs(Isaac.GetRoomEntities()) do
            if e:IsVulnerableEnemy() and e.Position:Distance(mine.pos) < 40 and mine.armed then
                table.insert(toExplode, id)
                break
            end
        end
    end

    for _, id in ipairs(toExplode) do
        local mine = MINES[id]
        if mine then
            Game():BombExplosion(mine.pos)
            MINES[id] = nil
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    MINES = {}
end)

Isaac.DebugString("TearMines loaded! Watch your step!")
