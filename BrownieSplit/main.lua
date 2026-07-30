-- ==========================================================================
--  Brownie Split - The Binding of Isaac: Repentance
--  Brownie splits into 2 Dips + 2 Squirts on death rather than just dips.
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("BrownieSplit", 1)

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    if npc.Type == EntityType.ENTITY_BROWNIE then
        local room = Game():GetRoom()
        if not room then return end

        for i = 1, 2 do
            local dipPos = npc.Position + Vector((i - 1.5) * 30, -30)
            local dip = Isaac.Spawn(EntityType.ENTITY_DIP, 0, 0, dipPos,
                Vector((i - 1.5) * 2, -3), npc)
            if dip then
                dip:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
            end
        end

        for i = 1, 2 do
            local squirtPos = npc.Position + Vector((i - 1.5) * 30, 30)
            local squirt = Isaac.Spawn(EntityType.ENTITY_SQUIRT, 0, 0, squirtPos,
                Vector((i - 1.5) * 2, 3), npc)
            if squirt then
                squirt:AddEntityFlags(EntityFlag.FLAG_CHAMPION)
            end
        end
    end
end)

Isaac.DebugString("BrownieSplit loaded!")
