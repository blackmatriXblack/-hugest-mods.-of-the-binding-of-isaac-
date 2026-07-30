-- ==========================================================================
--  Tainted Loki Quad - The Binding of Isaac: Repentance
--  Tainted Loki — creates 4 illusion copies instead of 2.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedLokiQuad", 1)
local LOKI_ID = EntityType.ENTITY_LOKI
local illusion_data = {}

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == LOKI_ID then
        local room = Game():GetRoom()
        if not room then return end

        if not illusion_data[npc.InitSeed] then
            illusion_data[npc.InitSeed] = {illusions = {}, timer = 0}
        end

        local data = illusion_data[npc.InitSeed]
        data.timer = data.timer + 1

        if data.timer % 180 == 0 then
            for _, ill in ipairs(data.illusions) do
                if ill.Exists and ill:Exists() then ill:Remove() end
            end
            data.illusions = {}

            for i = 1, 4 do
                local angle = (i / 4) * math.pi * 2
                local offset = Vector.FromAngle(angle) * 80
                local ill = Isaac.Spawn(EntityType.ENTITY_LOKI, 0, 0,
                    npc.Position + offset, Vector.Zero, npc)
                if ill then
                    ill:AddEntityFlags(EntityFlag.FLAG_NO_TARGET)
                    table.insert(data.illusions, ill)
                end
            end
        end
    end
end)

Isaac.DebugString("TaintedLokiQuad loaded!")
