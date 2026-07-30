-- ==========================================================================
--  RandomSoundboard - The Binding of Isaac: Repentance
--  Random funny sound effects play on kills — soundboard chaos!
--  Version: 1.0   |   Official API only
-- ==========================================================================

local mod = RegisterMod("RandomSoundboard", 1)

local FUNNY_SOUNDS = {
    SoundEffect.SOUND_MONSTER_GRUNT_0,
    SoundEffect.SOUND_MONSTER_GRUNT_1,
    SoundEffect.SOUND_MONSTER_GRUNT_2,
    SoundEffect.SOUND_MONSTER_GRUNT_3,
    SoundEffect.SOUND_MONSTER_GRUNT_4,
    SoundEffect.SOUND_MONSTER_GRUNT_5,
    SoundEffect.SOUND_BABY_HURT,
    SoundEffect.SOUND_BOSS_LITE_ROAR,
    SoundEffect.SOUND_ISAAC_HURT,
    SoundEffect.SOUND_CHILD_CRY,
    SoundEffect.SOUND_COIN_SLOT,
    SoundEffect.SOUND_FART,
    SoundEffect.SOUND_BURP,
    SoundEffect.SOUND_SCAMPER,
    SoundEffect.SOUND_SPLATTER,
    SoundEffect.SOUND_ROCK_CRUMBLE,
    SoundEffect.SOUND_BONE_BONK,
    SoundEffect.SOUND_MEATY_DEATHS,
    SoundEffect.SOUND_BLOODBANK,
    SoundEffect.SOUND_EVIL_LAUGH,
    SoundEffect.SOUND_STONE_SHATTER,
}

mod:AddCallback(ModCallbacks.MC_POST_NPC_DEATH, function(_, npc)
    local soundID = FUNNY_SOUNDS[math.random(#FUNNY_SOUNDS)]
    local pitch = 0.5 + math.random() * 2.0
    local volume = npc:IsBoss() and 0.8 or 0.35

    SFXManager():Play(soundID, volume, 0, false, pitch)

    if npc:IsBoss() then
        local combo = {SoundEffect.SOUND_BOSS2INTRO, SoundEffect.SOUND_MEGA_BLAST, SoundEffect.SOUND_CHALLENGE_COMPLETE}
        SFXManager():Play(combo[math.random(#combo)], 0.6, 0, false, 0.8 + math.random() * 0.4)
    end

    if math.random() < 0.15 then
        SFXManager():Play(SoundEffect.SOUND_FART, 0.2, 0, false, 0.5 + math.random() * 1.5)
    end
end)

Isaac.DebugString("RandomSoundboard loaded! WAHOO! BOING! SPLAT!")
