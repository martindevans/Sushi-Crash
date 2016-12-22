--data/items.lua contains data parsed directly out of the game files (and in a rather inconvenient format). This file accesses that raw data and
--presents it in a more convenient format.

local items = require("src/game/data/items");

local module = {}

module.GetItemData = function(name)
  local item = items[name];
  if not item then
    error("No such item '" .. tostring(name) .. "'");
  end
  
  --Convert some flags into a more useful format
  item.ItemStackable = item.ItemStackable == "1";
  
  return item;
end

return module;