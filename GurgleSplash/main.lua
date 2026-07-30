-- =============================================================================
--  GurgleSplash - The Binding of Isaac: Repentance
--  Gurgle leaves water creep puddles that slow the player
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("GurgleSplash", 1)
local GURGLE_TYPE = 267
local CREEP_INTERVAL = 12 -- frames between creep placements
local SLOW_CREEP_VARIANT = 2 -- water/blue creep that slows

function mod:OnNPCUpdate(npc)
    if npc.Type ~= GURGLE_TYPE then return end

    local data = npc:GetData()
    data.creepTimer = (data.creepTimer or 0) + 1

    if data.creepTimer >= CREEP_INTERVAL then
        data.creepTimer = 0

        -- Leave water creep at current position
        Isaac.GridSpawn(GridEntityType.GRID_CREEP, SLOW_CREEP_VARIANT, npc.Position, true)

        -- Also leave creep behind in opposite direction of movement
        if npc.Velocity:Length() > 0.5 then
            local behind = npc.Position - npc.Velocity:Normalized() * 30
            Isaac.GridSpawn(GridEntityType.GRID_CREEP, SLOW_CREEP_VARIANT, behind, true)
        end
    end

    -- If player is on water creep from Gurgle, apply extra slow
    local player = Isaac.GetPlayer(0)
    if player and player.Position:Distance(npc.Position) < 120 then
        local room = Game():GetRoom()
        local gridIdx = room:GetGridIndex(player.Position)
        local gridEntity = room:GetGridEntity(gridIdx)
        if gridEntity and gridEntity:GetType() == GridEntityType.GRID_CREEP then
            player:AddSlowing(EntityRef(npc), 20, 0.6, 0)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("GurgleSplash loaded!")
