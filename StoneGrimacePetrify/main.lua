-- ==========================================================================
--  StoneGrimacePetrify - The Binding of Isaac: Repentance
--  Stone Grimace gaze petrifies player briefly when facing it
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("StoneGrimacePetrify", 1)
local game = Game()
local GRIMACE_TYPE = EntityType.ENTITY_GRIMACE
local STONE_VARIANT = 4
local lastPetrify = {}

function mod:petrifyUpdate(_, npc)
    if npc.Type ~= GRIMACE_TYPE or npc.Variant ~= STONE_VARIANT then return end
    local player = game:GetPlayer(0)
    if not player then return end
    if npc.Position:Distance(player.Position) < 200 then
        local dirToPlayer = (player.Position - npc.Position):Normalized()
        local faceDir = Vector(math.cos(npc:GetDropRNG():RandomFloat() * 6.28), math.sin(npc:GetDropRNG():RandomFloat() * 6.28))
        local idx = GetPtrHash(npc)
        if lastPetrify[idx] == nil then lastPetrify[idx] = 0 end
        lastPetrify[idx] = lastPetrify[idx] + 1
        if lastPetrify[idx] > 120 then
            player:AddControlsCooldown(30)
            lastPetrify[idx] = 0
        end
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NPC_UPDATE, mod.petrifyUpdate, GRIMACE_TYPE)
Isaac.DebugString("StoneGrimacePetrify loaded!")
