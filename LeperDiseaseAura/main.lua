-- =============================================================================
--  LeperDiseaseAura - The Binding of Isaac: Repentance
--  Leper has a poison damage aura around it
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("LeperDiseaseAura", 1)
local LEPER_TYPE = 235
local AURA_RADIUS = 80
local POISON_DMG = 0.5
local POISON_DURATION = 90
local AURA_TICK = 15

function mod:OnNPCUpdate(npc)
    if npc.Type ~= LEPER_TYPE then return end

    local player = Isaac.GetPlayer(0)
    if not player then return end

    local dist = player.Position:Distance(npc.Position)

    if dist <= AURA_RADIUS then
        local data = npc:GetData()
        data.auraTick = (data.auraTick or 0) + 1
        if data.auraTick >= AURA_TICK then
            data.auraTick = 0
            -- Apply poison to player and spawn green creep
            player:AddPoison(EntityRef(npc), POISON_DURATION, POISON_DMG)

            -- Spawn green poison creep under the player
            local creepSpawn = player.Position + Vector(math.random(-10, 10), math.random(-10, 10))
            Isaac.GridSpawn(GridEntityType.GRID_CREEP, 1, creepSpawn, true) -- variant 1 = green creep
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("LeperDiseaseAura loaded!")
