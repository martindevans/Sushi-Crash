--data/items.lua contains data parsed directly out of the game files (and in a rather inconvenient format). This file accesses that raw data and
--presents it in a more convenient format.

local items = require("src/game/data/items");

local module = {}

local function func_field(item, name, func)
  if item[name] ~= nil then
    item[name] = item[name] == func(item[name]);
  end
end

local function bool_field(item, name)
  func_field(item, name, function(v) return v == "1"; end);
end

local function num_field(item, name)
  func_field(item, name, function(v) return tonumber(v); end);
end

local function find_ability(item_data, key)
  for _, ability in ipairs(item_data.AbilitySpecial) do
    if ability[key] ~= nil then
      return ability[key];
    end
  end

  return nil;
end

module.GetBonusStr = function(item_data)
  return (find_ability(item_data, "bonus_all_stats") or 0)
       + (find_ability(item_data, "bonus_strength") or 0);
end

module.GetBonusInt = function(item_data)
  return (find_ability(item_data, "bonus_all_stats") or 0)
       + (find_ability(item_data, "bonus_intelligence") or 0);
end

module.GetBonusAgi = function(item_data)
  return (find_ability(item_data, "bonus_all_stats") or 0)
       + (find_ability(item_data, "bonus_agility") or 0);
end

module.GetItemData = function(name)
  local item = items[name];
  if not item then
    error("No such item '" .. tostring(name) .. "'");
  end
  
  --Convert some flags into a more useful format
  bool_field(item, "ItemStackable");
  num_field(item, "ItemCost");
  bool_field(item, "SecretShop");

  if item.AbilitySpecial ~= nil then
    for _, ability in ipairs(item.AbilitySpecial) do
      if ability.var_type == "FIELD_INTEGER" or ability.var_type == "FIELD_FLOAT" then
        for k, v in pairs(ability) do
          if k ~= "var_type" then
            ability[k] = tonumber(v);

            if ability[k] == nil then
              error("Cannot parse items with multiple bonuses! (" .. tostring(name) .. ")");
            end

            break;
          end
        end
      end
    end
  end
  
  item.GetBonusAgi = GetBonusAgi;
  item.GetBonusInt = GetBonusInt;
  item.GetBonusStr = GetBonusStr;

  return item;
end

if test then
  test("GetItemData for all items", function()
    for k, v in pairs(items) do
      if k ~= "Version" then
        print("GetItemData(" .. tostring(k) .. ")");
        local data = module.GetItemData(k);
      end
    end
  end);
end

return module;