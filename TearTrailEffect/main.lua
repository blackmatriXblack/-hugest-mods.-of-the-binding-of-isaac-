-- ==========================================================================
--  TearTrailEffect - The Binding of Isaac: Repentance
--  Tears leave a fading colored trail behind them for visual flair!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TearTrailEffect", 1)
local TRAIL_INTERVAL = 2
local tearTrails = {}

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    local id = tear.InitSeed
    if not tearTrails[id] then
        tearTrails[id] = {
            counter = 0,
            hue = math.random(0, 360) / 360,
            positions = {}
        }
    end

    local data = tearTrails[id]
    data.counter = data.counter + 1

    if data.counter % TRAIL_INTERVAL == 0 then
        table.insert(data.positions, {
            pos = tear.Position,
            alpha = 1
        })
        if #data.positions > 8 then
            table.remove(data.positions, 1)
        end
    end

    for i, tp in ipairs(data.positions) do
        tp.alpha = i / #data.positions * 0.4

        local trail = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.SPARKLE, 0,
            tp.pos, Vector.Zero, nil)
        if trail then
            trail:SetTimeout(3)
            local h = data.hue
            local r = math.sin(h * math.pi * 2) * 0.5 + 0.5
            local g = math.sin((h + 0.33) * math.pi * 2) * 0.5 + 0.5
            local b = math.sin((h + 0.67) * math.pi * 2) * 0.5 + 0.5
            trail:SetColor(Color(r, g, b, 1, 0, 0, 0), 0, 0)
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, function()
    tearTrails = {}
end)

Isaac.DebugString("TearTrailEffect loaded! Rainbow trails!")
