local mod = RegisterMod("EntityFireProjectileDemo", 1)
local timer = 0

function mod:onUpdate()
    timer = timer + 1
    if timer >= 150 then
        timer = 0
        local entities = Isaac.GetRoomEntities()
        for i = 0, entities.Size - 1 do
            local e = entities:Get(i)
            if e:IsEnemy() and e:Exists() then
                local player = Isaac.GetPlayer(0)
                local vel = (player.Position - e.Position):Normalized() * 4
                e:FireProjectiles(e.Position, vel * 1.5, 0, ProjectileParams())
                break
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_UPDATE, mod.onUpdate)
