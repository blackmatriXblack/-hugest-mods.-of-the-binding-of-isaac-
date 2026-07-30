-- ==========================================================================
--  ExorcistBanish - The Binding of Isaac: Repentance
--  Exorcist attempts to banish player's active item temporarily disabling it
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("ExorcistBanish", 1)
local game = Game()
local EXORCIST_TYPE = EntityType.ENTITY_EXORCIST

function mod:banishUpdate(_, npc)
    if npc.Type ~= EXORCIST_TYPE then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.FrameCount % 300 == 0 and npc.Position:Distance(player.Position) < 250 then
        npc:PlaySound(SoundEffect.SOUND_HOLY, 1, 0, false, 1)
        player:AnimateCollectible(CollectibleType.COLLECTIBLE_NULL, "HideItem", "PlayerPickup")
        -- Disable active item briefly by setting charge to 0 and preventing use
        for i = 0, 1 do
            local charge = player:GetActiveCharge(i)
            if charge > 0 and player:GetActiveItem(i) ~= CollectibleType.COLLECTIBLE_NULL then
                player:SetActiveCharge(math.max(charge - 2, 0), i)
            end
        end
        local halo = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HALO, 0, player.Position, Vector.Zero, npc)
        if halo then halo:GetSprite().Color = Color(0.5, 0, 1, 0.7, 0, 0, 0) end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.banishUpdate, EXORCIST_TYPE)
Isaac.DebugString("ExorcistBanish loaded!")
