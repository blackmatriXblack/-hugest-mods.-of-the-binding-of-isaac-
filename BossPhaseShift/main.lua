local mod = RegisterMod("BossPhaseShift", 1)
local game = Game()
local bossVisible = {}
local timer = 0

function mod:onUpdate()
    timer = timer + 1
    if timer < 180 then return end
    timer = 0
    local entities = Isaac.GetRoomEntities()
    for _, e in ipairs(entities) do
        if e:IsBoss() and e:Exists() then
            local uid = e:GetEntityID()
            bossVisible[uid] = not bossVisible[uid]
            e.Visible = bossVisible[uid]
        end
    end
end

mod:AddCallback(5, mod.onUpdate) -- MC_POST_UPDATE
Isaac.DebugString("BossPhaseShift: Bosses randomly go invisible and reappear!")
