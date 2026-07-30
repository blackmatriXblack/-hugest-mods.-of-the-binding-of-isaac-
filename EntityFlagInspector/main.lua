local mod = RegisterMod("EntityFlagInspector", 1)
local player = Isaac.GetPlayer(0)

function mod:onRender()
    if not Input.IsActionPressed(32, 0) then return end -- Spacebar check
    local entities = Isaac.GetRoomEntities()
    local nearest = nil
    local minDist = 9999
    for _, e in ipairs(entities) do
        if e:IsEnemy() and e:Exists() then
            local d = (e.Position - player.Position):Length()
            if d < minDist then minDist = d; nearest = e end
        end
    end
    if nearest then
        local flags = {1,2,4,8,16,32,64,128,256,512,1024,2048,4096,8192}
        local active = {}
        for _, f in ipairs(flags) do
            if nearest:HasEntityFlags(f) then table.insert(active, tostring(f)) end
        end
        Isaac.RenderText("Flags: " .. table.concat(active, ","), 10, 56, 1, 1, 1, 0, 1)
    end
end

mod:AddCallback(4, mod.onRender) -- MC_POST_RENDER
Isaac.DebugString("EntityFlagInspector: Hold Space to see nearest enemy's flags!")
