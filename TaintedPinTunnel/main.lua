-- ==========================================================================
--  Tainted Pin Tunnel - The Binding of Isaac: Repentance
--  Tainted Pin — creates 3 tunnels simultaneously, popping randomly.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("TaintedPinTunnel", 1)
local PIN_ID = EntityType.ENTITY_PIN
local tunnel_positions = {}
local pop_timer = 0

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, function(_, npc)
    if npc.Type == PIN_ID then
        local room = Game():GetRoom()
        if not room then return end

        pop_timer = pop_timer + 1

        if pop_timer % 90 == 0 then
            tunnel_positions = {}
            for i = 1, 3 do
                local x = room:GetLeftWallPos() + math.random() * (room:GetRightWallPos() - room:GetLeftWallPos())
                local y = room:GetTopLeftPos().Y + math.random() * (room:GetBottomRightPos().Y - room:GetTopLeftPos().Y)
                table.insert(tunnel_positions, Vector(x, y))
            end
        end

        if pop_timer % 25 == 0 and #tunnel_positions > 0 then
            local emergePos = tunnel_positions[math.random(#tunnel_positions)]
            npc.Position = emergePos
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.WATER_SPLASH, 0,
                emergePos, Vector.Zero, npc)
        end
    end
end)

Isaac.DebugString("TaintedPinTunnel loaded!")
