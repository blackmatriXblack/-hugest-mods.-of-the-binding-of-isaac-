-- =============================================================================
--  The Hollow Echo - The Binding of Isaac: Repentance
--  At half HP, The Hollow creates a ghost copy that mirrors its attacks.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TheHollowEcho", 1)
local game = Game()

local HOLLOW_TYPE = 211 -- EntityType.ENTITY_HOLLOW
local hasEchoed = {}

local function onNPCUpdate(_, npc)
    if npc.Type ~= HOLLOW_TYPE then return end
    if npc:IsDead() then
        hasEchoed[GetPtrHash(npc)] = nil
        return
    end

    local ptr = GetPtrHash(npc)
    local maxHp = npc.MaxHitPoints
    local curHp = npc.HitPoints

    if not hasEchoed[ptr] and curHp > 0 and curHp <= maxHp * 0.5 then
        hasEchoed[ptr] = true

        -- Spawn ghost copy at opposite side of the room
        local room = game:GetRoom()
        local center = room:GetCenterPos()
        local mirrorPos = Vector(
            center.X + (center.X - npc.Position.X),
            center.Y + (center.Y - npc.Position.Y)
        )
        local echo = Isaac.Spawn(HOLLOW_TYPE, npc.Variant, npc.SubType, mirrorPos, Vector.Zero, npc)
        if echo then
            echo.HitPoints = npc.HitPoints * 0.5
            echo.Scale = 0.85
            -- Ghostly transparency effect
            echo:AddEntityFlags(EntityFlag.FLAG_APPEAR, false)
            echo:AddEntityFlags(EntityFlag.FLAG_NO_FLASH_ON_DAMAGE, true)
            -- Tint slightly blue/transparent
            echo.Color = Color(0.6, 0.6, 1.0, 0.6, 0, 0, 0)
        end
    end

    -- Ghost copy mirrors parent's movement with delay
    if hasEchoed[ptr] then
        local entities = Isaac.GetRoomEntities()
        for _, ent in ipairs(entities) do
            if ent.Type == HOLLOW_TYPE and ent.Index ~= npc.Index
                and ent.HitPoints > 0 and not ent:IsDead()
                and ent.Scale < 0.9 then
                -- Ghost AI: mirror movement
                local toPlayer = (ent.Position - npc.Position):Normalized()
                ent.Velocity = toPlayer * 2.5
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("TheHollowEcho loaded!")
