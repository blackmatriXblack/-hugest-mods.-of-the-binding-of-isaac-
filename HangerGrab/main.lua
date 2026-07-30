-- =============================================================================
--  HangerGrab - The Binding of Isaac: Repentance
--  Hanger slowly pulls the player toward it with a gravitational force
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("HangerGrab", 1)
local HANGER_TYPE = 40 -- EntityType.ENTITY_HANGER
local PULL_RANGE = 200
local PULL_FORCE = 0.05

local function onNPCUpdate(_, entity)
    if entity.Type ~= HANGER_TYPE or not entity:Exists() then
        return
    end

    local pos = entity.Position
    for p = 0, Game():GetNumPlayers() - 1 do
        local player = Isaac.GetPlayer(p)
        if player and player:Exists() then
            local dist = pos:Distance(player.Position)
            if dist < PULL_RANGE and dist > 10 then
                -- Gravitational pull toward hanger
                local pullDir = (pos - player.Position):Normalized()
                local force = PULL_FORCE * (1 - dist / PULL_RANGE) -- stronger when closer
                player.Velocity = player.Velocity + pullDir * force

                -- Visual feedback: slow the player down with a purple tint
                local t = 1 - dist / PULL_RANGE
                player:SetColor(Color(1, 1 - t * 0.3, 1, 1, 0, 0, 0), 2, 0, false, true)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("HangerGrab loaded!")
