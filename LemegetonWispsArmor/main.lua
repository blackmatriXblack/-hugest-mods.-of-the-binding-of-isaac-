-- ==========================================================================
--  Lemegeton Wisps Armor - The Binding of Isaac: Repentance
--  Lemegeton wisps each grant +0.2 flat damage while alive
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("LemegetonWispsArmor", 1)
local game = Game()

local LEMEGETON = CollectibleType.COLLECTIBLE_LEMEGETON
local wispDamagePer = 0.2

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(LEMEGETON) then return end

    local wispCount = 0
    local entities = Isaac.GetRoomEntities()
    for _, ent in ipairs(entities) do
        if ent.Type == EntityType.ENTITY_FAMILIAR then
            local fam = ent:ToFamiliar()
            if fam and fam.Variant == FamiliarVariant.LEMEGETON_WISP then
                wispCount = wispCount + 1
            end
        end
    end

    if wispCount > 0 then
        -- Apply temporary damage boost based on wisp count
        local bonusDamage = wispCount * wispDamagePer
        local effects = player:GetEffects()
        effects:AddCollectibleEffect(CollectibleType.COLLECTIBLE_LEMEGETON, false, 1)
        Isaac.RenderText("Wisps: " .. wispCount .. " (+" ..
            string.format("%.1f", bonusDamage) .. " DMG)",
            50, 70, 1, 0.3, 0.8, 1, 0.8)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("LemegetonWispsArmor loaded!")
