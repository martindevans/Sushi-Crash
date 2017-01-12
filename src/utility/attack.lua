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

    local base_damage = atk.AttackDamageMin;
    local attrs, primary_attr_name = dota_hero.GetCurrentAttributes();

    --http://dota2.gamepedia.com/Attack_damage
    --We skip target armour, target damage block and crits
    return (
            (base_damage + primary_attr)
            * (1 + sum_pcnt_attack_modifiers)
            + bonus_damage - dmg_block
        )
        * (product_dmg_multipliers);

    

    --accumulate damage amount
    local dmg = atk.AttackDamageMin;

    local primary_attr = 0;

    --Add passive damage bonuses from items
    for i = 1, 6 do
        local item = bot:GetItemInSlot(i);
        if item then
            dmg = dmg + dota_items.GetItemData(item).GetAbilitySpecialValue("bonus_damage");
        end
    end

    --Bonuses from buffs
    --todo ^

    --Bonuses from auto attack spells
    --todo ^
end

return module;