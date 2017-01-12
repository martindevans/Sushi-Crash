--data/heroes.lua contains data parsed directly out of the game files (and in a rather inconvenient format). This file accesses that raw data and
--presents it in a more convenient format.

local heroes = require("src/game/data/heroes");

local base_hero = heroes.npc_dota_hero_base;
for k, v in pairs(heroes) do

  --set the fallback for all heroes to hero_base
  if not (k == "Version" or k == "npc_dota_hero_base" or type(v) ~= "table") then
    setmetatable(v, { __index = base_hero });
  end

end

local module = {};

--Get a table of information about auto attacks
module.GetAttackInfo = function(bot)
  local name = bot:GetUnitName();
  local hero = heroes[name];
  if not hero then
    error(string.format("Warning: Cannot find hero '%s'", name));
    return {};
  end

  --[[
    "AttackCapabilities"		"DOTA_UNIT_CAP_RANGED_ATTACK"
		"AttackDamageMin"		"1"
		"AttackDamageMax"		"1"
		"AttackDamageType"		"DAMAGE_TYPE_ArmorPhysical"
		"AttackRate"		"1.700000"
		"AttackAnimationPoint"		"0.750000"
		"AttackAcquisitionRange"		"800"
		"AttackRange"		"600"
		"ProjectileModel"		"particles/base_attacks/ranged_hero.vpcf"
		"ProjectileSpeed"		"900"
  ]]
  if hero.ParsedAutoAttackData == nil then
    hero.ParsedAutoAttackData = {
      AttackDamageMin = tonumber(hero.AttackDamageMin),
      AttackDamageMax = tonumber(hero.AttackDamageMax),
      AttackDamageType = hero.AttackDamageType,
      AttackAnimationPoint = tonumber(hero.AttackAnimationPoint),
      AttackRange = tonumber(hero.AttackRange),
      ProjectileSpeed = tonumber(hero.ProjectileSpeed),
    }
  end

  return hero.ParsedAutoAttackData;
end

--Returns a table of attributes followed by the primary attribute key (not affected by items)
--[[
  {
    str = 1,
    int = 2,
    agi = 3,
  }, int
]]
module.GetBaseAttributes = function(bot)
  local name = bot:GetUnitName();
  local hero = heroes[name];
  if not hero then
    error(string.format("Warning: Cannot find hero '%s'", name));
    return {}, nil;
  end

  --todo: GET BOT LEVEL
  local level = 1;

  --Calculate basic attributes from level
  local attr = {
    str = hero.AttributeBaseStrength + hero.AttributeStrengthGain * level,
    int = hero.AttributeBaseIntelligence + hero.AttributeIntelligenceGain * level,
    agi = hero.AttributeBaseAgility + hero.AttributeAgilityGain * level
  }
  local primary = "";
  if hero.AttributePrimary == "DOTA_ATTRIBUTE_INTELLECT" then
    primary = "int";
  elseif hero.AttributePrimary == "DOTA_ATTRIBUTE_STRENGTH" then
    primary = "str";
  else
    primary = "agi";
  end

  return attr, primary;
end

module.GetCurrentAttributes = function(bot)
  local attr, primary = module.GetBaseAttributes(bot);

  --Add bonuses from items
    for i = 1, 6 do
        local item = bot:GetItemInSlot(i);
        if item then
            local item_data = dota_items.GetItemData(item);

            if item_data.AbilityBehavior == "DOTA_ABILITY_BEHAVIOR_PASSIVE" then

              --Apply passive item bonuses
              attr.str = attr.str + item_data:GetBonusStr();
              attr.int = attr.int + item_data:GetBonusInt();
              attr.agi = attr.agi + item_data:GetBonusAgi();

            elseif false then

              --TODO: Apply active item bonuses

            end
        end
    end

    --Bonuses from buffs
    --todo ^
end

module.GetAbilitiesNames = function(bot)
  local name = bot:GetUnitName();
  local hero = heroes[name];
  if not hero then
    error(string.format("Warning: Cannot find hero '%s'", name));
    return {};
  end

  local ability_count = tonumber(hero.AbilityLayout);
  local abilities = {};

  for i = 1, ability_count do
    abilities[i] = hero["Ability" .. tostring(i)];
  end

  return abilities;
end

module.GetAbilities = function(bot)

  local names = module.GetAbilitiesNames(bot);

  local result = {};
  for _, v in ipairs(names) do
    result[v] = bot:GetAbilityByName(v);

    if not result[v] then
      print(string.format("Warning: Cannot find ability '%s' for hero '%s'", v, name));
    end
  end

  return result;
end

module.GetRecommendedItemBuild = function(bot)
  local name = bot:GetUnitName();
  local hero = heroes[name];
  if not hero then
    string.format("Warning: Cannot find hero '%s'", name);
    return {};
  end
  
  if not hero.Bot or not hero.Bot.Loadout then return {}; end
  
  local items = {};
  for k, v in pairs(hero.Bot.Loadout) do
    table.insert(items, v.item_name);
  end
  
  return items;
end

if test then
  test("Anti mage has appropriate skills", function()
    local skills = module.GetAbilitiesNames({
      GetUnitName = function() return "npc_dota_hero_antimage" end
    });
    
    assert(tonumber(heroes["npc_dota_hero_antimage"].AbilityLayout) == 4, "Expected 4 skills, got '" .. tostring(heroes["npc_dota_hero_antimage"].AbilityLayout) .. "'");
    assert(skills[1] == "antimage_mana_break", "expected 'antimage_mana_break' but got '" .. tostring(skills[1] .. "'"));
    assert(skills[2] == "antimage_blink", "expected 'antimage_blink' but got '" .. tostring(skills[1] .. "'"));
    assert(skills[3] == "antimage_spell_shield", "expected 'antimage_spell_shield' but got '" .. tostring(skills[1] .. "'"));
    assert(skills[4] == "antimage_mana_void", "expected 'antimage_mana_void' but got '" .. tostring(skills[1] .. "'"));
  end);
end

return module;
