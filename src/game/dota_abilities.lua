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
  }
};

local module = {};

module.GetAbilities = function(bot)
  local name = bot:GetUnitName();
  local abilities = hero_ability_names[name];
  if not abilities then
    print(string.format("Warning: Cannot find ability list for hero '%s'", name));
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
