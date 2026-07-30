-- =============================================================================
--  MusicTrackDisplay — The Binding of Isaac: Repentance
--  Display current music track name on screen.
--  Version: 1.0   | Official API only
-- =============================================================================

local mod = RegisterMod("MusicTrackDisplay", 1)
local game = Game()

function mod:onPostRender()
    local music = Music()
    if not music then
        Isaac.RenderText("Music: No track", 10, 130, 0.8, 0.8, 1, 0.5, 0.5)
        return
    end

    local trackId = music:GetCurrentMusicTrack()
    local trackName = "Unknown"
    -- Map common track IDs to names (Music enum values)
    local trackNames = {
        [0] = "None / Jukebox",
        [1] = "Basement",
        [2] = "Cellar",
        [3] = "Burning Basement",
        [4] = "Caves",
        [5] = "Catacombs",
        [6] = "Flooded Caves",
        [7] = "Depths",
        [8] = "Necropolis",
        [9] = "Dank Depths",
        [10] = "Womb",
        [11] = "Utero",
        [12] = "Scarred Womb",
        [13] = "Sheol",
        [14] = "Cathedral",
        [15] = "Dark Room",
        [16] = "Chest",
        [17] = "Boss Fight",
        [18] = "Boss Rush",
        [19] = "Angel Room",
        [20] = "Devil Room",
        [21] = "Secret Room",
        [22] = "Shop",
        [23] = "Library",
        [24] = "Arcade",
        [25] = "Sacrifice Room",
        [26] = "Planetarium",
        [27] = "Isaac Fight",
        [28] = "Satan Fight",
        [29] = "Mega Satan Fight",
        [30] = "Hush Fight",
        [31] = "Delirium Fight",
        [32] = "Mother Fight",
        [33] = "Dogma Fight",
        [34] = "Beast Fight",
        [100] = "Custom/Unknown",
    }

    trackName = trackNames[trackId] or ("TrackID:" .. tostring(trackId))
    Isaac.RenderText("Music: " .. trackName, 10, 130, 0.8, 0.8, 0.4, 0.8, 1)
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onPostRender)
Isaac.DebugString("MusicTrackDisplay loaded!")
