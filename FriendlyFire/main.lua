-- ==========================================================================
--  Friendly Fire - The Binding of Isaac: Repentance
--  Player's own tears can damage the player — realistic mode!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("FriendlyFire", 1)
local game = Game()
local playerTears = {}

mod:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, function(_, tear)
    tear:AddEntityFlags(EntityFlag.FLAG_FRIENDLY)
    tear:ClearEntityFlags(EntityFlag.FLAG_NO_DAMAGE_BLINK)
    playerTears[tear.InitSeed] = tear
end)

mod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, function(_, tear)
    if not playerTears[tear.InitSeed] then return end

    local player = game:GetPlayer(0)
    if not player then return end

    -- Check if tear hit the player
    local dist = (tear.Position - player.Position):Length()
    if dist < 15 then
        player:TakeDamage(tear.CollisionDamage,
            DamageFlag.DAMAGE_FAKE | DamageFlag.DAMAGE_NO_PENALTIES,
            EntityRef(tear), 0)
        tear:Remove()
        playerTears[tear.InitSeed] = nil
        Isaac.DebugString("Watch your own tears!")
    end

    -- Clean up destroyed tears
    if tear:IsDead() then
        playerTears[tear.InitSeed] = nil
    end
end)

Isaac.DebugString("Friendly Fire loaded!")
