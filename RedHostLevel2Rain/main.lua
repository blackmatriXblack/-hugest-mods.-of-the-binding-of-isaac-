-- ==========================================================================
--  RedHostLevel2Rain - The Binding of Isaac: Repentance
--  Level 2 Red Host fires 3 bullet spreads upward that rain down across the room.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RedHostLevel2Rain", 1)
local ENEMY_RED_HOST = 29
local RAIN_INTERVAL = 150
local RAIN_BULLETS = 5

local function onNPCUpdate(_, npc)
    if npc.Type ~= ENEMY_RED_HOST or npc.Variant ~= 1 then return end
    local data = npc:GetData()
    if not data.rainTimer then data.rainTimer = 0 end

    data.rainTimer = data.rainTimer + 1
    if data.rainTimer >= RAIN_INTERVAL then
        data.rainTimer = 0
        local room = Game():GetRoom()
        local topleft = room:GetTopLeftPos()
        local botright = room:GetBottomRightPos()
        -- Fire 3 spreads upward that rain down
        for wave = 1, 3 do
            local spreadX = topleft.X + (botright.X - topleft.X) * (wave / 4)
            for i = 1, RAIN_BULLETS do
                local pos = Vector(spreadX, topleft.Y - 40)
                local offset = Vector((i - 3) * 20, 0)
                local bullet = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, ProjectileVariant.PROJECTILE_NORMAL, 0, pos + offset, Vector(0, 5), npc)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("RedHostLevel2Rain loaded!")