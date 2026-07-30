local mod = RegisterMod("EntitySpriteInspector", 1)
local input = Input()

function mod:onRender()
    if input:IsButtonPressed(Keyboard.KEY_TAB, 0) then
        local player = Isaac.GetPlayer(0)
        local entities = Isaac.GetRoomEntities()
        local nearest = nil
        local nearestDist = 99999
        for i = 0, entities.Size - 1 do
            local e = entities:Get(i)
            if e:IsEnemy() then
                local dist = player.Position:Distance(e.Position)
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = e
                end
            end
        end
        if nearest then
            local spr = nearest:GetSprite()
            Isaac.DebugString("Sprite: " .. spr:GetFilename() .. " Anim:" .. spr:GetAnimation())
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_RENDER, mod.onRender)
