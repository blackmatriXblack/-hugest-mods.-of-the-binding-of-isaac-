-- =============================================================================
--  PlayerChangeWisp — The Binding of Isaac: Repentance
--  MC_POST_PLAYER_CHANGE: When switching characters (eg. Esau/Jacob),
--  spawn 3 blue wisps around the new character.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PlayerChangeWisp", 1)

function mod:onPostPlayerChange(player)
    if not player:Exists() then return end

    local pos = player.Position
    local offsets = {
        Vector(0, -40),
        Vector(35, 20),
        Vector(-35, 20),
    }

    for _, offset in ipairs(offsets) do
        local wisp = Isaac.Spawn(
            EntityType.ENTITY_FAMILIAR,
            FamiliarVariant.BLUE_FLY,
            0,
            pos + offset,
            Vector.Zero,
            player
        )
        -- Set as wisp/orbital if possible
        if wisp then
            local familiar = wisp:ToFamiliar()
            if familiar then
                familiar.Player = player
            end
        end
    end
end
mod:AddCallback(ModCallbacks.MC_POST_PLAYER_CHANGE, mod.onPostPlayerChange)

Isaac.DebugString("PlayerChangeWisp loaded!")
