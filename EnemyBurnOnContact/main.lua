local mod = RegisterMod("EnemyBurnOnContact", 1)
local player = Isaac.GetPlayer(0)

function mod:onUpdate()
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            local dist = (e.Position - player.Position):Length()
            if dist < 30 then
                e:AddBurn(EntityRef(player), 120)
            end
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemyBurnOnContact: Enemies touching player (dist<30) get burned!")
