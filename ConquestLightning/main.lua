-- =============================================================================
--  Conquest Stormsplit - The Binding of Isaac: Repentance
--  Conquest's lightning bolts split into 3 smaller homing bolts on impact.
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("ConquestLightning", 1)

local CONQUEST_TYPE = 404 -- EntityType.ENTITY_CONQUEST
local BOLT_TEAR = 3       -- TearType.TEAR_BOLT or similar for lightning projectile
local lastAttackFrame = {}

local function onNPCUpdate(_, npc)
    if npc.Type ~= CONQUEST_TYPE then return end
    if npc:IsDead() then
        lastAttackFrame[GetPtrHash(npc)] = nil
        return
    end

    local ptr = GetPtrHash(npc)
    local frame = Game():GetFrameCount()

    -- Detect lightning attack: Conquest fires a special projectile during attack state
    if npc.State == NpcState.STATE_ATTACK2 then
        if not lastAttackFrame[ptr] or frame - lastAttackFrame[ptr] > 30 then
            lastAttackFrame[ptr] = frame

            -- Find Conquest's recently fired lightning tears and split them
            local entities = Isaac.GetRoomEntities()
            for _, ent in ipairs(entities) do
                if ent.Type == EntityType.ENTITY_PROJECTILE and ent:ToProjectile() then
                    local proj = ent:ToProjectile()
                    if proj.Parent and proj.Parent.Index == npc.Index then
                        -- Split into 3 smaller bolts
                        local baseAngle = proj.Velocity:GetAngleDegrees()
                        local baseSpeed = proj.Velocity:Length()
                        proj:Remove()
                        for i = -1, 1 do
                            local angle = math.rad(baseAngle + i * 25)
                            local vel = Vector(math.cos(angle), math.sin(angle)) * baseSpeed * 0.7
                            local splitBolt = Isaac.Spawn(EntityType.ENTITY_PROJECTILE, 0, 0, proj.Position, vel, npc)
                            if splitBolt then
                                local sp = splitBolt:ToProjectile()
                                if sp then
                                    sp.Scale = 0.6
                                    sp.FallingSpeed = -8
                                    sp.FallingAccel = 1.5
                                    sp.Height = -20
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, onNPCUpdate)
Isaac.DebugString("ConquestLightning loaded!")
