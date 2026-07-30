-- Force clear room if any enemies are present
local mod = RegisterMod("RoomForceClear", 1)
local game = Game()

function mod:onPostUpdate()
    local room = game:GetRoom()
    if room then
        local enemies = Isaac.GetRoomEntities()
        local hasEnemy = false
        for _, e in ipairs(enemies) do
            if e:IsVulnerableEnemy() then
                hasEnemy = true
                break
            end
        end
        if hasEnemy then
            room:Clear()
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onPostUpdate)
Isaac.DebugString("RoomForceClear loaded! Auto-clears rooms with enemies.")
