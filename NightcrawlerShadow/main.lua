-- =============================================================================
--  NightcrawlerShadow — The Binding of Isaac: Repentance
--  Nightcrawlers (Type=39) become invisible in dark rooms (Curse of Darkness).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("NightcrawlerShadow", 1)
local game = Game()

function mod:onNpcUpdate(npc)
    if npc.Type ~= 39 then return end
    local room = game:GetRoom()
    local isDark = room:GetDisplayFlags() & RoomDescriptor.DISPLAY_DARKNESS ~= 0
    local alpha = isDark and 0.15 or 1.0
    local color = npc:GetColor()
    npc:SetColor(Color(color.R, color.G, color.B, alpha, color.RO, color.GO, color.BO))
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.onNpcUpdate)
Isaac.DebugString("NightcrawlerShadow loaded!")
