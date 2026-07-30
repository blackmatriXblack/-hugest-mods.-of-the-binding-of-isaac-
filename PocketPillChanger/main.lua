local mod = RegisterMod("PocketPillChanger", 1)
local game = Game()

function mod:onNewRoom()
    local player = Isaac.GetPlayer(0)
    local pill = player:GetPill(0)
    player:SetPill(0, 0)
    Isaac.DebugString("Pill effect ID: " .. tostring(pill))
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
