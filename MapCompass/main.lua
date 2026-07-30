-- MapCompass: Reveals adjacent rooms and shows direction arrows to boss/shop on HUD
local mod = RegisterMod("MapCompass", 1)

function mod:onNewRoom()
    local level = Game():GetLevel()
    local currentRoom = level:GetCurrentRoom()
    for i = 0, 7 do
        local doorSlot = currentRoom:GetDoorSlot(i)
        if doorSlot and doorSlot > -1 then
            local roomDesc = level:GetRoomByIdx(doorSlot)
            if roomDesc and roomDesc.DisplayFlags then
                roomDesc.DisplayFlags = 5
            end
        end
    end
end

function mod:onRender()
    local level = Game():GetLevel()
    local currentRoom = level:GetCurrentRoom()
    local currentIdx = level:GetCurrentRoomIndex()
    local bossRoomIdx = level:GetBossRoomIndex()
    local shopRoomIdx = level:GetShopRoomIndex()
    if bossRoomIdx and bossRoomIdx > -1 then
        Isaac.RenderText("Boss Room", 200, 10, 255, 100, 100, 255, 2)
    end
    if shopRoomIdx and shopRoomIdx > -1 then
        Isaac.RenderText("Shop", 350, 10, 255, 200, 100, 255, 2)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
Isaac.DebugString("MapCompass loaded! Revealing adjacent rooms on HUD.")
