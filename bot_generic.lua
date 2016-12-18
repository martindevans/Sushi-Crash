local abilities = require(GetScriptDirectory() .. "/src/game/dota_abilities");
local map = require(GetScriptDirectory() .. "/src/game/dota_map");

function DebugDrawJungle(jungle)
  for _, camp in ipairs(jungle) do
    local prev = camp.farm_spot;
    DebugDrawCircle(prev, 10, 255, 100, 0);
    for _, p in ipairs(camp.pull_path) do
      DebugDrawLine(prev, p, 0, 255, 0);
      DebugDrawCircle(p, 10, 0, 255, 100);
      prev = p;
    end
  end
end

function DebugDrawMap()
  --DebugDrawJungle(map.jungle.radiant_primary);
  --DebugDrawJungle(map.jungle.radiant_secondary);

  DebugDrawJungle(map.jungle.dire_primary);
  DebugDrawJungle(map.jungle.dire_secondary);
end

local bot = GetBot();
local bot_abilities = abilities.GetAbilities(bot);

function Think()
  DebugDrawMap();

  --Try to buy items
  if TryToBuyItems(bot) then
    return;
  end

  --Try to level abilities
  TryToLevel(bot);

  --Reset back to start state if we're dead
  if not bot:IsAlive() then
    return;
  end

  --Are we channeling an ability (e.g. a teleport). If so just don't think (average dota2 player *rimshot*)
  if bot:IsChanneling() then
    return;
  end

  --Flee!
  if bot:GetHealth() < bot:GetMaxHealth() * 0.35 then
    if TP_To_Fountain(bot) then
      return;
    end
  end

  --If we're already attacking a target finish off what we're doing before changing
  if IsAttacking(bot) then
    if RandomFloat(0, 1) > 0.9 then
      UseARandomAbility();
    end
    return;
  end

  --Set move target to far end of lane (attacking all targets on the way)
  WalkDownLane(bot)

  --Find a target to attack
  local doing_stuff = AttackNearbyHeroes(bot) or AttackNearbyBuildings(bot) AttackNearbyCreepsWithoutPushingLane(bot);
end

function UseARandomAbility()

  if not bot:GetAttackTarget():IsHero() then
    return;
  end

  for k, v in pairs(bot_abilities) do

    --we don't know what the hell we're trying to cast, or how to cast it. Just try all the possibilities!
    if v:IsFullyCastable() then bot:Action_UseAbility(v); end
    if v:IsFullyCastable() then bot:Action_UseAbilityOnEntity(v, bot:GetAttackTarget()); end
    if v:IsFullyCastable() then bot:Action_UseAbilityOnLocation(v, bot:GetAttackTarget():GetExtrapolatedLocation(0.15)); end

  end
end

function TryToBuyItems(bot)
  return bot:Action_PurchaseItem("item_tpscroll") == PURCHASE_ITEM_SUCCESS;
end

function TryToLevel(bot)
  for k, v in pairs(bot_abilities) do
    if v:GetLevel() < v:GetMaxLevel() then
      v:UpgradeAbility();
    end
  end
end

--Find an inventory item by name (or nil)
function FindInventoryItem(bot, name)
  for i = 0, 6 do
    local item = bot:GetItemInSlot(i);
    if item and item:GetName() == name then
      return item;
    end
  end

  return nil;
end

--Find or buy a TP scroll
function GetTpScroll(bot)

  --Find TP in inventory
  local tp = FindInventoryItem(bot, "item_tpscroll");
  if tp then return tp; end

  --No luck, buy a TP instead
  local purchased = bot:Action_PurchaseItem("item_tpscroll") == PURCHASE_ITEM_SUCCESS;
  if not purchased then return nil; end

  return FindInventoryItem(bot, "item_tpscroll");
end

function TP_To_Fountain(bot)
  local tp = GetTpScroll(bot);

  --No TP, so we can't TP
  if not tp then
    return false;
  end

  --TP is on cooldown, so we can't TP
  if tp:GetCooldownTimeRemaining() > 0 then
    return false;
  end

  --Yay, we can TP
  bot:Action_UseAbilityOnLocation(tp, GetLocationAlongLane(LANE_MID, 0));
end

function WalkDownLane(bot)
  local target = GetLocationAlongLane(LANE_MID, 0.99);
  bot:Action_AttackMove(target);
end

function IsAttacking(bot)
  local target = bot:GetAttackTarget();

  --No target, or target is dead
  if not target or not target:IsAlive() then
    return false;
  end

  --Target is out of range
  if GetUnitToUnitDistance(bot, target) > 800 then
    return false;
  end

  return true;
end

function AttackNearbyHeroes(bot)

  local enemies = bot:GetNearbyHeroes(700, true, BOT_MODE_NONE);
  for i, v in pairs(enemies) do
    bot:Action_AttackUnit(v, false);
    return true;
  end

  return false;

end

function AttackNearbyBuildings(bot)

  local enemies = bot:GetNearbyTowers(700, true);
  for i, v in pairs(enemies) do
    bot:Action_AttackUnit(v, false);
    return true;
  end

  return false;

end

function AttackNearbyCreepsWithoutPushingLane(bot)

  local enemies = bot:GetNearbyCreeps(750, true);

  --Find the enemy on lowest health
  local lowest_hp = 9999999;
  local lowest = nil;
  for _, v in pairs(enemies) do
    local hp = v:GetHealth();
    if hp < lowest_hp then
      lowest_hp = hp;
      lowest = v;
    end
  end

  if lowest then

    --we found a creep, but can we one shot it to get the last hit?
    local estimated_damage = bot:GetEstimatedDamageToTarget(false, lowest, 1, DAMAGE_TYPE_PHYSICAL);
    if estimated_damage > lowest_hp then
      --print(string.format("Attacking %s %s > %s", lowest:GetUnitName(), estimated_damage, lowest_hp));
      bot:Action_AttackUnit(lowest, false);
      return true;
    end

  end

  return false;

end
