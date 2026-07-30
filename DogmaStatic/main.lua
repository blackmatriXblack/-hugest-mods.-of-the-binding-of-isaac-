-- ==========================================================================
--  Dogma Static - The Binding of Isaac: Repentance
--  Dogma boss — static TV effect periodically obscures half the screen.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("DogmaStatic", 1)
local static_active = false
local static_timer = 0
local static_side = 0

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_DOGMA then
        static_timer = static_timer + 1
        if static_timer >= 90 then
            static_timer = 0
            static_active = true
            static_side = math.floor(math.random() * 2)
            Isaac.GetPlayer(0):SetMinDamageCooldown(60)
        end
        if static_active then
            static_timer = static_timer + 1
            if static_timer > 60 then
                static_active = false
                static_timer = 0
            end
        end
    end
end)

mod:AddCallback(ModCallbacks.MC_POST_RENDER, function()
    if not static_active then return end
    local screenW = Isaac.GetScreenWidth()
    local screenH = Isaac.GetScreenHeight()
    if static_side == 0 then
        Isaac.RenderRectangle(0, 0, screenW / 2, screenH, 0, 0, 0, 200)
    else
        Isaac.RenderRectangle(screenW / 2, 0, screenW / 2, screenH, 0, 0, 0, 200)
    end
end)

Isaac.DebugString("DogmaStatic loaded!")
