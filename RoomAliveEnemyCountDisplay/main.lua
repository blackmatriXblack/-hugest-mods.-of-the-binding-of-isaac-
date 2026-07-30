local mod = RegisterMod("RoomAliveEnemyCount", 1)
local level = Game():GetLevel()

function mod:onRender()
    local room = level:GetCurrentRoom()
    local count = 0
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then count = count + 1 end
    end
    Isaac.RenderText("Enemies Alive: " .. count, 10, 8, 1, 1, 1, 1, 1)
end

mod:AddCallback(4, mod.onRender) -- MC_POST_RENDER
Isaac.DebugString("RoomAliveEnemyCountDisplay: HUD shows alive enemy count!")
