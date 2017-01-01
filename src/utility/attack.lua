local dota_heroes = require("src/game/dota_heroes");
local dota_items = require("src/game/dota_items");

local module = {};

--Calculate how much damage an attack from this hero does. Returns a table of damage types mapped to amounts. e.g.
-- {
--    DAMAGE_TYPE_PHYSICAL = 1,
--    DAMAGE_TYPE_MAGICAL = 0,
--    DAMAGE_TYPE_PURE = 2,
-- }
module.GetAttackDamage = function(bot)
    local atk = dota_heroes.GetAttackInfo(bot);

    --accumulate damage amount
    local dmg = atk.AttackDamageMin;

    --Add bonuses from items
    for i = 1, 6 do
        local item = bot:GetItemInSlot(i);
        if item then
            local item_data = dota_items.GetItemData(item);
            if item_data.AbilityBehavior == "DOTA_ABILITY_BEHAVIOR_PASSIVE" then
                
            elseif false then

            end
        end
    end

    --Bonuses from buffs
    --todo ^

    --Bonuses from orbs
    --todo ^
end

return module;