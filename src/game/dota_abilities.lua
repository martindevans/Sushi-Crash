--[[

  I found this wiki page which I have added abilities from: https://developer.valvesoftware.com/wiki/Dota_2_Workshop_Tools/Scripting/Built-In_Ability_Names
  Someone else pointed me to this other file which is better: https://github.com/SteamDatabase/GameTracking-Dota2/blob/master/game/dota/pak01_dir/scripts/npc/npc_heroes.txt

]]

local hero_ability_names = {
  ["npc_dota_hero_lion"] = {
    "lion_impale",
    "lion_mana_drain",
    "lion_voodoo",
    "lion_finger_of_death"
  },

  ["npc_dota_hero_viper"] = {
    "viper_corrosive_skin",
    "viper_nethertoxin",
    "viper_poison_attack",
    "viper_viper_strike",
  },

  ["npc_dota_hero_juggernaut"] = {
    "juggernaut_blade_dance",
    "juggernaut_blade_fury",
    "juggernaut_healing_ward",
    "juggernaut_omni_slash"
  },

  ["npc_dota_hero_dragon_knight"] = {
    "dragon_knight_breathe_fire",
    "dragon_knight_dragon_blood",
    "dragon_knight_dragon_tail",
    "dragon_knight_elder_dragon_form"
  },

  ["npc_dota_hero_sand_king"] = {
    "sandking_burrowstrike",
    "sandking_caustic_finale",
    "sandking_epicenter",
    "sandking_sand_storm"
  },

  ["npc_dota_hero_sven"] = {
    "sven_gods_strength",
    "sven_great_cleave",
    "sven_storm_bolt",
    "sven_warcry"
  },

  ["npc_dota_hero_skywrath_mage"] = {
    "skywrath_mage_ancient_seal",
    "skywrath_mage_arcane_bolt",
    "skywrath_mage_concussive_shot",
    "skywrath_mage_mystic_flare"
  },

  ["npc_dota_hero_phantom_assassin"] = {
    "phantom_assassin_blur",
    "phantom_assassin_coup_de_grace",
    "phantom_assassin_phantom_strike",
    "phantom_assassin_stifling_dagger"
  },

  ["npc_dota_hero_bloodseeker"] = {
    "bloodseeker_bloodrage",
    "bloodseeker_blood_bath",
    "bloodseeker_rupture",
    "bloodseeker_thirst"
  },

  ["npc_dota_hero_vengefulspirit"] = {
    "vengefulspirit_command_aura",
    "vengefulspirit_magic_missile",
    "vengefulspirit_nether_swap",
    "vengefulspirit_wave_of_terror"
  },

  ["npc_dota_hero_bane"] = {
    "bane_brain_sap",
    "bane_enfeeble",
    "bane_fiends_grip",
    "bane_nightmare",
    "bane_nightmare_end"
  },

  ["npc_dota_hero_witch_doctor"] = {
    "witch_doctor_death_ward",
    "witch_doctor_maledict",
    "witch_doctor_paralyzing_cask",
    "witch_doctor_voodoo_restoration"
  },

  ["npc_dota_hero_pudge"] = {
    "pudge_dismember",
    "pudge_flesh_heap",
    "pudge_meat_hook",
    "pudge_rot"
  },

  ["npc_dota_hero_sniper"] = {
    "sniper_assassinate",
    "sniper_headshot",
    "sniper_shrapnel",
    "sniper_take_aim"
  },

  ["npc_dota_hero_drow_ranger"] = {
    "drow_ranger_frost_arrows",
    "drow_ranger_marksmanship",
    "drow_ranger_wave_of_silence",
    "drow_ranger_trueshot"
  },

  ["npc_dota_hero_lina"] = {
    "lina_dragon_slave",
    "lina_fiery_soul",
    "lina_laguna_blade",
    "lina_light_strike_array"
  },

  ["npc_dota_hero_axe"] = {
    "axe_battle_hunger",
    "axe_berserkers_call",
    "axe_counter_helix",
    "axe_culling_blade"
  },

  ["npc_dota_hero_razor"] = {
    "razor_eye_of_the_storm",
    "razor_plasma_field",
    "razor_static_link",
    "razor_unstable_current"
  },

  ["npc_dota_hero_nevermore"] = {
    "nevermore_dark_lord",
    "nevermore_necromastery",
    "nevermore_requiem",
    "nevermore_shadowraze1",
    "nevermore_shadowraze2",
    "nevermore_shadowraze3"
  },

  ["npc_dota_hero_tidehunter"] = {
    "tidehunter_anchor_smash",
    "tidehunter_gush",
    "tidehunter_kraken_shell",
    "tidehunter_ravage"
  },

  ["npc_dota_hero_necrolyte"] = {
    "necrolyte_death_pulse",
    "necrolyte_heartstopper_aura",
    "necrolyte_reapers_scythe",
    "necrolyte_sadist"
  },

  ["npc_dota_hero_bristleback"] = {
    "bristleback_bristleback",
    "bristleback_quill_spray",
    "bristleback_viscous_nasal_goo",
    "bristleback_warpath"
  },

  ["npc_dota_hero_chaos_knight"] = {
    "chaos_knight_chaos_bolt",
    "chaos_knight_chaos_strike",
    "chaos_knight_phantasm",
    "chaos_knight_reality_rift"
  },

  ["npc_dota_hero_windrunner"] = {
    "windrunner_focusfire",
    "windrunner_powershot",
    "windrunner_shackleshot",
    "windrunner_windrun"
  },

  ["npc_dota_hero_luna"] = {
    "luna_eclipse",
    "luna_lucent_beam",
    "luna_lunar_blessing",
    "luna_moon_glaive"
  },

  ["npc_dota_hero_tiny"] = {
    "tiny_avalanche",
    "tiny_craggy_exterior",
    "tiny_grow",
    "tiny_toss"
  },

  ["npc_dota_hero_crystal_maiden"] = {
    "crystal_maiden_brilliance_aura",
    "crystal_maiden_crystal_nova",
    "crystal_maiden_freezing_field",
    "crystal_maiden_frostbite"
  },

  ["npc_dota_hero_earthshaker"] = {
    "earthshaker_aftershock",
    "earthshaker_echo_slam",
    "earthshaker_enchant_totem",
    "earthshaker_fissure"
  },

  ["npc_dota_hero_death_prophet"] = {
    "death_prophet_carrion_swarm",
    "death_prophet_exorcism",
    "death_prophet_silence",
    "death_prophet_spirit_siphon"
  },

  ["npc_dota_hero_warlock"] = {
    "warlock_fatal_bonds",
    "warlock_rain_of_chaos",
    "warlock_shadow_word",
    "warlock_upheaval"
  },

  ["npc_dota_hero_bounty_hunter"] = {
    "bounty_hunter_jinada",
    "bounty_hunter_shuriken_toss",
    "bounty_hunter_track",
    "bounty_hunter_wind_walk"
  },

  ["npc_dota_hero_oracle"] = {
    "oracle_false_promise",
    "oracle_fates_edict",
    "oracle_fortunes_end",
    "oracle_purifying_flames"
  },

  ["npc_dota_hero_jakiro"] = {
    "jakiro_dual_breath",
    "jakiro_ice_path",
    "jakiro_liquid_fire",
    "jakiro_macropyre"
  },

  ["npc_dota_hero_meepo"] = {
    "meepo_divided_we_stand",
    "meepo_earthbind",
    "meepo_geostrike",
    "meepo_poof"
  },

  ["npc_dota_hero_visage"] = {
    "visage_gravekeepers_cloak",
    "visage_grave_chill",
    "visage_soul_assumption",
    "visage_summon_familiars",
  },

  ["npc_dota_hero_broodmother"] = {
    "broodmother_incapacitating_bite",
    "broodmother_insatiable_hunger",
    "broodmother_spawn_spiderlings",
    "broodmother_spin_web"
  },

  ["npc_dota_hero_phantom_lancer"] = {
    "phantom_lancer_doppelwalk",
    "phantom_lancer_juxtapose",
    "phantom_lancer_phantom_edge",
    "phantom_lancer_spirit_lance"
  },

  ["npc_dota_hero_furion"] = {
    "furion_force_of_nature",
    "furion_sprout",
    "furion_teleportation",
    "furion_wrath_of_nature"
  }
};

local module = {};

module.GetAbilities = function(bot)
  local name = bot:GetUnitName();
  local abilities = hero_ability_names[name];
  if not abilities then
    print(string.format("Warning: Cannot find ability list for hero '%s'", name));
    return {}
  end

  local result = {};
  for k, v in ipairs(abilities) do
    result[v] = bot:GetAbilityByName(v);

    if not result[v] then
      print(string.format("Warning: Cannot find ability '%s' for hero '%s'", v, name));
    end
  end

  return result;
end

return module;
