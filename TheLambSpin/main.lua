-- =============================================================================
--  TheLambSpin - The Binding of Isaac: Repentance
--  The Lamb's spinning charge attack fires rotating brimstone in all directions
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("TheLambSpin", 1)
local THE_LAMB_ID = 273
local isSpinning = false
local spinStartFrame = 0
local lastFireFrame = 0

function mod:OnNPCUpdate(npc)
    if npc.Type ~= THE_LAMB_ID then return end
    if not npc:IsActiveEnemy() then return end

    local frame = Game():GetFrameCount()
    local player = Isaac.GetPlayer(0)
    if not player or not player:Exists() then return end

    -- Detect spinning charge: high velocity + angular movement
    local speed = npc.Velocity:Length()

    if speed > 6 and not isSpinning then
        -- Just started spinning
        isSpinning = true
        spinStartFrame = frame
        lastFireFrame = frame
    elseif speed < 3 and isSpinning then
        -- Stopped spinning
        isSpinning = false
    end

    -- During spin, fire rotating brimstone every 5 frames
    if isSpinning and frame - lastFireFrame >= 5 then
        lastFireFrame = frame

        local elapsed = frame - spinStartFrame
        -- Rotating angle pattern
        local fireCount = math.floor(elapsed / 5)
        local angle = (fireCount * 20) * math.pi / 180 -- 20 degree rotation per burst

        -- Fire in 4 rotating directions
        for i = 0, 3 do
            local baseAngle = angle + (i * math.pi / 2) -- 0, 90, 180, 270 offset
            local dir = Vector(math.cos(baseAngle), math.sin(baseAngle))

            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                npc.Position, dir * 5, npc):ToTear()
            if tear then
                tear:AddTearFlags(TearFlags.TEAR_BRIMSTONE)
                tear:AddTearFlags(TearFlags.TEAR_SPECTRAL)
                tear.Scale = 2.0
                tear:SetColor(Color(0.1, 0.1, 0.1, 1, 0, 0, 0), 0, 0)
            end
        end

        -- Extra brimstone lasers in between (8-way rotating)
        if fireCount % 2 == 0 then
            for i = 0, 7 do
                local baseAngle = angle + (i * math.pi / 4)
                local dir = Vector(math.cos(baseAngle), math.sin(baseAngle))

                local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0,
                    npc.Position, dir * 3, npc):ToTear()
                if tear then
                    tear:AddTearFlags(TearFlags.TEAR_BRIMSTONE)
                    tear.Scale = 1.2
                end
            end
        end

        -- Visual trail
        if fireCount % 10 == 0 then
            Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.BLOOD_EXPLOSION, 0,
                npc.Position, Vector(0, 0), nil)
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("TheLambSpin loaded!")
