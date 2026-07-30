-- ==========================================================================
--  Ultra War Bombs - The Binding of Isaac: Repentance
--  Ultra War's bombs have 2x radius and leave permanent fires.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("UltraWarBombs", 1)
local WAR_ID = EntityType.ENTITY_WAR
local tracked_bombs = {}

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == WAR_ID then
        local room = Game():GetRoom()
        if not room then return end

        if npc.FrameCount % 90 == 0 then
            local player = Isaac.GetPlayer(0)
            if not player then return end

            local pos = npc.Position
            for i = 1, 3 do
                local offset = Vector((i - 2) * 60, 0)
                local bomb = Isaac.Spawn(EntityType.ENTITY_BOMB, 0, 0,
                    pos + offset, Vector.Zero, npc)
                if bomb then
                    bomb.SpriteScale = Vector(1.5, 1.5)
                    tracked_bombs[bomb.Index] = {pos = bomb.Position, timer = 60}
                end
            end
        end

        for idx, data in pairs(tracked_bombs) do
            data.timer = data.timer - 1
            if data.timer <= 0 then
                Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.HOT_BOMB_FIRE, 0,
                    data.pos, Vector.Zero, nil)
                tracked_bombs[idx] = nil
            end
        end
    end
end)

Isaac.DebugString("UltraWarBombs loaded!")
