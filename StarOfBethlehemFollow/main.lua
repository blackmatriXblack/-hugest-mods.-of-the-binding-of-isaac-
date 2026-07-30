-- ==========================================================================
--  Star of Bethlehem Follow - The Binding of Isaac: Repentance
--  Star of Bethlehem moves 50 percent faster toward the player
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("StarOfBethlehemFollow", 1)
local game = Game()

local STAR = CollectibleType.COLLECTIBLE_STAR_OF_BETHLEHEM

function mod:onNewRoom()
end

function mod:onPlayerUpdate(player)
    if not player:HasCollectible(STAR) then return end
    for i = 0, 127 do
        local ent = Isaac.GetRoomEntities()[i]
        if ent and ent.Type == EntityType.ENTITY_FAMILIAR then
            local fam = ent:ToFamiliar()
            if fam and fam.Variant == FamiliarVariant.STAR_OF_BETHLEHEM then
                local dir = (player.Position - fam.Position):Normalized()
                fam.Velocity = dir * 3.5
                break
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, mod.onPlayerUpdate)
Isaac.DebugString("StarOfBethlehemFollow loaded!")
