-- =============================================================================
--  PreSacrificeWarning - The Binding of Isaac: Repentance
--  Displays sacrifice tier number before taking damage on sacrifice spikes.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("PreSacrificeWarning", 1)
local sacrificeCount = 0
local displayTimer = 0

function mod:onPreSacrifice(player, numSacrifices)
    sacrificeCount = numSacrifices
    displayTimer = 90 -- 3 seconds

    local tierText = "Sacrifice #" .. numSacrifices
    if numSacrifices == 1 then tierText = tierText .. " (Nothing)" end
    if numSacrifices == 2 then tierText = tierText .. " (Nothing)" end
    if numSacrifices == 3 then tierText = tierText .. " (Heart chance)" end
    if numSacrifices == 4 then tierText = tierText .. " (Chest chance)" end
    if numSacrifices == 5 then tierText = tierText .. " (Coin drop)" end
    if numSacrifices == 6 then tierText = tierText .. " (Angel chance)" end
    if numSacrifices == 7 then tierText = tierText .. " (Angel item chance)" end
    if numSacrifices == 8 then tierText = tierText .. " (Soul hearts)" end
    if numSacrifices == 9 then tierText = tierText .. " (Uriel/Gabriel)" end
    if numSacrifices == 10 then tierText = tierText .. " (30 coins)" end
    if numSacrifices == 11 then tierText = tierText .. " (Angel item)" end
    if numSacrifices == 12 then tierText = tierText .. " (Soul heart ascent)" end
    if numSacrifices >= 13 then tierText = tierText .. " (Teleport to Dark Room)" end

    Isaac.DebugString(tierText)
end

function mod:onPostRender()
    if displayTimer <= 0 then return end
    displayTimer = displayTimer - 1
    Isaac.RenderText("Sacrifice #" .. sacrificeCount, 80, 80, 1, 0.8, 0.2, 1)
end

mod:AddCallback(ModCallbacks.MC_PRE_SACRIFICE, mod.onPreSacrifice)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("PreSacrificeWarning loaded!")
