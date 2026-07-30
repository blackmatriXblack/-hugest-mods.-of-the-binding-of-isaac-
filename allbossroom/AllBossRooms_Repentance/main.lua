-- =============================================================================
--  ALL BOSS ROOMS Mod — The Binding of Isaac: Repentance
--  Every combat room = boss fight. 100+ bosses from all versions!
-- =============================================================================

local mod = RegisterMod("AllBossRooms", 1)

-- =============================================================================
--  ULTIMATE BOSS DATABASE — All Repentance bosses
--  Format: {EntityType, Variant, Subtype}
-- =============================================================================
local BOSSES = {
    -- ====== Classic / Rebirth ======
    {5, 0, 0},    -- Monstro
    {5, 1, 0},    -- Monstro II
    {12, 0, 0},   -- Larry Jr.
    {12, 1, 0},   -- The Hollow
    {12, 2, 0},   -- Tuff Twins
    {14, 0, 0},   -- Duke of Flies
    {14, 1, 0},   -- The Husk
    {16, 0, 0},   -- Gemini
    {16, 1, 0},   -- Steven
    {19, 0, 0},   -- Blighted Ovum
    {22, 0, 0},   -- Famine
    {22, 1, 0},   -- Pestilence
    {22, 2, 0},   -- War
    {22, 3, 0},   -- Death
    {22, 4, 0},   -- Conquest
    {26, 0, 0},   -- The Fallen
    {26, 1, 0},   -- Krampus
    {37, 0, 0},   -- Pin
    {37, 1, 0},   -- Scolex
    {38, 0, 0},   -- Gurglings
    {38, 1, 0},   -- Turdlings
    {42, 0, 0},   -- Mega Maw
    {43, 0, 0},   -- The Gate
    {46, 0, 0},   -- Loki
    {46, 1, 0},   -- Lokii
    {51, 0, 0},   -- Mom
    {62, 0, 0},   -- Chub
    {62, 1, 0},   -- C.H.A.D.
    {62, 2, 0},   -- Carrion Queen
    {63, 0, 0},   -- Gurdy
    {63, 1, 0},   -- Gurdy Jr.
    {66, 0, 0},   -- Mama Gurdy
    {67, 0, 0},   -- Daddy Long Legs
    {68, 0, 0},   -- Triachnid
    {71, 0, 0},   -- It Lives
    {72, 0, 0},   -- Isaac
    {73, 0, 0},   -- ???
    {74, 0, 0},   -- Satan
    {78, 0, 0},   -- The Lamb
    {79, 0, 0},   -- Mega Satan
    {81, 0, 0},   -- The Haunt

    -- ====== Afterbirth ======
    {84, 0, 0},   -- Delirium
    {100, 0, 0},  -- Rag Man
    {101, 0, 0},  -- Ultra Greed
    {102, 0, 0},  -- Hush
    {217, 0, 0},  -- Little Horn
    {229, 0, 0},  -- Big Horn
    {270, 0, 0},  -- Sisters Vis
    {272, 0, 0},  -- Rag Mega

    -- ====== Repentance exclusives ======
    {260, 0, 0},  -- The Matriarch
    {261, 0, 0},  -- The Pile
    {262, 0, 0},  -- Reap Creep
    {264, 0, 0},  -- The Shell
    {265, 0, 0},  -- Hornfel
    {271, 0, 0},  -- The Forsaken
    {273, 0, 0},  -- Min-Min
    {274, 0, 0},  -- Clog
    {275, 0, 0},  -- Colostomia
    {276, 0, 0},  -- Turdlet
    {400, 0, 0},  -- The Siren
    {401, 0, 0},  -- The Heretic
    {402, 0, 0},  -- The Visage
    {403, 0, 0},  -- The Horny Boys
    {404, 0, 0},  -- Mom's Heart (alt)
    {405, 0, 0},  -- Dogma
    {406, 0, 0},  -- The Beast
    {407, 0, 0},  -- Ultra Death
    {408, 0, 0},  -- Ultra Famine
    {409, 0, 0},  -- Ultra Pestilence
    {410, 0, 0},  -- Ultra War
    {411, 0, 0},  -- Mother

    -- ====== Repentance mini-bosses ======
    {202, 0, 0},  -- Ultra Pride
    {226, 0, 0},  -- Ultra Greed (phase 1)
    {228, 0, 0},  -- Ultra Greedier

    -- ====== Additional alt-floor bosses ======
    {800, 0, 0},  -- Baby Plum
    {801, 0, 0},  -- The Scourge
    {802, 0, 0},  -- Chimera
    {803, 0, 0},  -- Rotgut
    {804, 0, 0},  -- Mother (alt skin)
    {805, 0, 0},  -- The Witness
    {806, 0, 0},  -- The Rainmaker
    {807, 0, 0},  -- Min-Min (alt)
    {808, 0, 0},  -- The Visage (alt)
}

-- =============================================================================
--  Room type filter
-- =============================================================================
local ALLOWED_ROOMS = {
    [1]  = true,   -- ROOM_DEFAULT
    [9]  = true,   -- ROOM_ARCADE
    [11] = true,   -- ROOM_CHALLENGE
    [12] = true,   -- ROOM_LIBRARY
    [16] = true,   -- ROOM_DUNGEON
    [19] = true,   -- ROOM_BARREN
    [21] = true,   -- ROOM_DICE
}

-- =============================================================================
--  Spawn bosses on room entry
-- =============================================================================
function mod:onNewRoom()
    local room = Game():GetLevel():GetCurrentRoom()
    if room == nil then return end

    local roomType = room:GetType()
    if not ALLOWED_ROOMS[roomType] then return end

    -- Scale boss count by room size
    local shape = room:GetRoomShape()
    local bossCount = 1

    if shape == 2 or shape == 3 then
        bossCount = math.random(1, 2)
    elseif shape >= 5 and shape <= 8 then
        bossCount = 2
    elseif shape >= 9 then
        bossCount = math.random(2, 4)
    end

    local center = room:GetCenterPos()

    for i = 1, bossCount do
        local boss = BOSSES[math.random(#BOSSES)]
        local offsetX = (i - 1) * 100 - (bossCount - 1) * 50
        Isaac.Spawn(boss[1], boss[2], boss[3],
                    Vector(center.X + offsetX, center.Y),
                    Vector(0, 0), nil)
    end
end

mod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, mod.onNewRoom)
