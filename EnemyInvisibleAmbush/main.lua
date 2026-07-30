local mod = RegisterMod("EnemyInvisibleAmbush", 1)
local game = Game()
local timer = 0
local hideTimer = 0
local hidden = false

function mod:onUpdate()
    timer = timer + 1
    if not hidden and timer >= 600 then
        hidden = true
        hideTimer = 90
        timer = 0
        local entities = Isaac.GetRoomEntities()
        for _, e in ipairs(entities) do
            if e:IsEnemy() and e:Exists() then
                e.Visible = false
            end
        end
    end
    if hidden then
        hideTimer = hideTimer - 1
        if hideTimer <= 0 then
            hidden = false
            local entities = Isaac.GetRoomEntities()
            for _, e in ipairs(entities) do
                if e:IsEnemy() and e:Exists() then
                    e.Visible = true
                end
            end
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("EnemyInvisibleAmbush: Enemies go invisible every 20s for 3s!")
