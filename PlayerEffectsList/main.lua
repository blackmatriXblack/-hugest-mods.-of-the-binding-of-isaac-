local mod = RegisterMod("PlayerEffectsList", 1)
local game = Game()

function mod:onRender()
    local player = Isaac.GetPlayer(0)
    local effects = player:GetEffects()
    local effectList = effects:GetCollectibleEffectList()
    local y = 100
    for i = 0, effectList.Size - 1 do
        local item = effectList:Get(i)
        Isaac.RenderText(item.Item:ToString() .. " [" .. tostring(item.Item.Id) .. "]", 50, y, 1, 1, 1, 255)
        y = y + 15
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
