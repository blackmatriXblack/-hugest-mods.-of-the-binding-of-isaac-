-- =============================================================================
--  BombPullEnemies - The Binding of Isaac: Repentance
--  Bombs pull enemies toward them before exploding (implosion effect).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("BombPullEnemies", 1)

local PULL_RADIUS = 200
local PULL_STRENGTH = 0.6
local activeBombs = {} -- { entity, timer }

function mod:onBombUpdate(bomb)
    if not bomb.Visible then return end

    local ptr = GetPtrHash(bomb)
    local found = false
    for _, b in ipairs(activeBombs) do
        if GetPtrHash(b.entity) == ptr then found = true; break end
    end
    if not found then
        table.insert(activeBombs, { entity = bomb, timer = 120 })
    end

    -- Pull enemies toward the bomb
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent:IsVulnerableEnemy() then
            local diff = bomb.Position - ent.Position
            local dist = diff:Length()
            if dist < PULL_RADIUS and dist > 10 then
                local strength = (1 - dist / PULL_RADIUS) * PULL_STRENGTH
                ent.Velocity = ent.Velocity + diff:Normalized() * strength * 0.5
                -- Visual: spiral particles would be nice but using color change
                ent:SetColor(Color(0.3, 0.0, 0.0, 1.0, 0, 0, 0), 2, 0)
            end
        end
    end

    -- Cleanup dead bombs
    for i = #activeBombs, 1, -1 do
        if not activeBombs[i].entity:Exists() then
            table.remove(activeBombs, i)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, mod.onBombUpdate)
Isaac.DebugString("BombPullEnemies loaded!")
