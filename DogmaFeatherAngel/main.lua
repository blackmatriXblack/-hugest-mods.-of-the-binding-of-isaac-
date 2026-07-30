-- =============================================================================
--  DogmaFeatherAngel — The Binding of Isaac: Repentance
--  Dogma's feather attack pattern is randomized (more feathers, random angles).
--  Version: 1.0   |   Official API only
-- =============================================================================

local mod = RegisterMod("DogmaFeatherAngel", 1)

local DOGMA_TYPE = 950

local featherCooldown = 0
local FEATHER_INTERVAL = 15

function mod:OnNPCUpdate(npc)
    if npc.Type ~= DOGMA_TYPE then return end

    featherCooldown = featherCooldown - 1
    if featherCooldown <= 0 then
        featherCooldown = FEATHER_INTERVAL

        local rng = RNG()
        rng:SetSeed(npc.InitSeed + Game():GetFrameCount(), 0)
        local featherCount = rng:RandomInt(5) + 4

        for i = 1, featherCount do
            local angle = rng:RandomFloat() * 360
            local rad = math.rad(angle)
            local vel = Vector(math.cos(rad) * 4, math.sin(rad) * 4)
            local tear = Isaac.Spawn(EntityType.ENTITY_TEAR, 0, 0, npc.Position, vel, npc)
            if tear then
                tear:AddEntityFlags(EntityFlag.FLAG_APPEAR)
            end
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.OnNPCUpdate)
Isaac.DebugString("DogmaFeatherAngel loaded!")
