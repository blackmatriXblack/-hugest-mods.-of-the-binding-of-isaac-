-- ==========================================================================
--  Tainted Delirium Mimic - The Binding of Isaac: Repentance
--  Tainted Delirium — briefly transforms into player's character model.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedDeliriumMimic", 1)
local mimic_timer = 0
local was_mimicking = false

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == EntityType.ENTITY_DELIRIUM then
        local player = Isaac.GetPlayer(0)
        if not player then return end

        mimic_timer = mimic_timer + 1

        if mimic_timer >= 300 and not was_mimicking then
            was_mimicking = true
            npc:GetSprite().Color = player:GetSprite().Color
            npc.SpriteScale = player.SpriteScale
            mimic_timer = 0
        end

        if was_mimicking and mimic_timer >= 120 then
            was_mimicking = false
            npc:GetSprite().Color = Color(1, 1, 1, 1, 0, 0, 0)
            npc.SpriteScale = Vector(1, 1)
            mimic_timer = 0
        end
    end
end)

Isaac.DebugString("TaintedDeliriumMimic loaded!")
