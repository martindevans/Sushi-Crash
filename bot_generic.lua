local abilities = require(GetScriptDirectory() .. "/src/game/dota_abilities");

function Think()
  local bot = GetBot();

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
  if bot:GetHealth() < bot:GetMaxHealth() * 0.65 then
    if TP_To_Fountain(bot) then
      return;
    end
  end

  --If we're already attacking a target finish off what we're doing before changing
  if IsAttacking(bot) then
    return;
  end

  --Set move target to far end of lane (attacking all targets on the way)
  WalkDownLane(bot)

  --Find a target to attack
  local doing_stuff = AttackNearbyHeroes(bot) or AttackNearbyBuildings(bot) or AttackNearbyCreeps(bot);
end

function TryToBuyItems(bot)
  return bot:Action_PurchaseItem("item_tpscroll") == PURCHASE_ITEM_SUCCESS;
end

function TryToLevel(bot)
  local bot_abilities = abilities.GetAbilities(bot);
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
  local target = GetLocationAlongLane(LANE_MID, 0.9);
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

function AttackNearbyCreeps(bot)

  local enemies = bot:GetNearbyCreeps(700, true);
  for i, v in pairs(enemies) do
    bot:Action_AttackUnit(v, false);
    return true;
  end

  return false;

end
