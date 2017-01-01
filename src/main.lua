--Import other modules we need
local map = require("src/game/dota_map");
local dota_heroes = require("src/game/dota_heroes");
local dota_items = require("src/game/dota_items");
local lane = require("src/utility/lane");
local linq = require("src/core/linq");
local coroutine_helpers = require("src/utility/coroutine_helpers");

--Create some globals with static information about this bot
local bot = GetBot();
local bot_abilities = dota_heroes.GetAbilities(bot);
local bot_attack = dota_heroes.GetAttackInfo(bot);

--Register this bot with the comms system to communicate with other bots
local comms = require("src/core/comms").RegisterBot(bot);


--Temp build guide following system
local bot_item_build = dota_heroes.GetRecommendedItemBuild(bot);
local next_item_index = 1;
local function TryToBuyItems(bot)
  if next_item_index > #bot_item_build then return; end
  if bot:GetGold() < GetItemCost(bot_item_build[next_item_index]) then return end;

  local name = bot_item_build[next_item_index];

  local result = bot:Action_PurchaseItem(name);

  if result == PURCHASE_ITEM_SUCCESS then
    print(bot:GetUnitName() .. " purchased " .. bot_item_build[next_item_index] .. ". Next is " .. (bot_item_build[next_item_index + 1] or "nothing!"));
    next_item_index = next_item_index + 1;
    return true;
  elseif result == PURCHASE_ITEM_INVALID_ITEM_NAME then
    print("Error! Unknown item: " .. tostring(name));
    next_item_index = next_item_index + 1;
    return false;
  elseif result == PURCHASE_ITEM_DISALLOWED_ITEM or result == PURCHASE_ITEM_INVALID_ITEM_NAME then
    print(bot:GetUnitName() .. " failed to purchase " .. bot_item_build[next_item_index] .. ". Moving on to " .. (bot_item_build[next_item_index + 1] or "nothing!"));
    next_item_index = next_item_index + 1;
    return false;
  end
end

--Temp levelling system
local function TryToLevel(bot)
  for k, v in pairs(bot_abilities) do
    if v:GetLevel() < v:GetMaxLevel() and v:CanAbilityBeUpgraded() then
      bot:Action_LevelAbility(v:GetName());
    end
  end
end

--Find an inventory item by name (or nil)
local function FindInventoryItem(bot, name)
  for i = 0, 6 do
    local item = bot:GetItemInSlot(i);
    if item and item:GetName() == name then
      return item;
    end
  end

  return nil;
end

function find_last_hit(enemies, allies)
    local found_creep = false;
    for _, creep in pairs(enemies) do

      if creep:IsCreep() then
        found_creep = true;
        DebugDrawCircle(creep:GetLocation(), 5, 0, 50, 255);
        DebugDrawLine(bot:GetLocation(), creep:GetLocation(), 255, 50, 0);

        local damage = creep:GetActualDamage(bot:GetBaseDamage(), DAMAGE_TYPE_PHYSICAL);
        if damage > creep:GetHealth() then
          return creep, true;
        end
      end
    end

    return nil, found_creep;
end

local function bounding_circle(units) --returns (center, radius) or (nil, nil) if there were no units
  local sum = Vector(0, 0);
  local cnt = 0;
  for _, v in pairs(units) do
    if v:IsAlive() then
      cnt = cnt + 1;
      sum = sum + v:GetLocation();
    end
  end

  if cnt == 0 then
    return nil, nil;
  end

  local center = sum / cnt;

  local rad = 0;
  for _, v in pairs(units) do
    local d = GetUnitToLocationDistance(v, center);
    rad = math.max(rad, d);
  end

  print(tostring(center) .. " " .. tostring(rad));
  return center, rad;
end

local function estimate_time_to_die(target, aggressors) --return (time_to_die, incoming_dps)
  local incoming_dps = linq.from_array(aggressors)
      .where(function(a) return a:GetAttackTarget() == target; end)
      .select(function(a) return a:GetBaseDamage() / a:GetSecondsPerAttack(); end)
      .aggregate(0, function(a, b) return a + b end);

  return target:GetHealth() / incoming_dps, incoming_dps
end

local function main_co()

  --Stay with the wave front until we see enemy creeps in range
  coroutine_helpers.wait_until(function()
    --Find enemies in sight
    local enemies = bot:GetNearbyCreeps(1500, true);

    --if we see no creeps advance to the wave front
    if #enemies == 0 then
      local loc = GetLaneFrontLocation(GetTeam(), LANE_MID, 0);
      bot:Action_MoveToLocation(loc);
    end

    print("Waiting for enemies");
    return #enemies > 0;
  end);

  --Find enemies and allies in sight
  enemies = bot:GetNearbyCreeps(1500, true);
  allies = bot:GetNearbyCreeps(1500, false);

  --Find the enemy creep which is most likely to die first
  local best_target = linq.from_array(enemies).select(function(c)

    local ttd, idps = estimate_time_to_die(c, allies);

    return {
      time_to_die = ttd,
      incoming_dps = idps,
      unit = c,
    }
  end).aggregate(nil, function(a, b)
    if not a then return b; end
    if a.time_to_die < b.time_to_die then return a; else return b; end
  end);

  --Attack that target, but be prepared to cancel the animation before it completes!
  if best_target then

    if GetUnitToUnitDistance(bot, best_target.unit) > bot_attack.AttackRange then
      --todo: Assess if this is a safe place to move to

      --Move to bot
      bot:Action_MoveToLocation(best_target.unit:GetLocation());
      coroutine_helpers.wait_until(function()
        return bot:GetCurrentActionType() ~= BOT_ACTION_TYPE_MOVE_TO;
      end);
    end

    bot:Action_AttackUnit(best_target.unit, true);

    --Wait for attack to *nearly* happen (minus 4 frames);
    coroutine_helpers.wait_for_duration(bot:GetAttackPoint() - 0.016 * 4, function()
	  print("Waiting to cancel: " .. tostring(bot:GetCurrentActionType() == BOT_ACTION_TYPE_ATTACK));
    end);

	  if not bot:GetCurrentActionType() == BOT_ACTION_TYPE_ATTACK then
		  print("Not attacking!");
	  else
      --ok now we really have to decide if we should cancel the attack or let it happen!
      local time = GetUnitToUnitDistance(bot, best_target.unit) / bot_attack.ProjectileSpeed;
      local _, idps = estimate_time_to_die(best_target.unit, bot:GetNearbyCreeps(1500, false));

      print("attack: hp=" .. tostring(best_target.unit:GetHealth()) .. " idps=" .. tostring(idps) .. " time=" .. tostring(time) .. " point=" .. tostring(bot:GetAttackPoint()) .. " dmg=" .. tostring(best_target.unit:GetActualDamage(bot:GetBaseDamage(), DAMAGE_TYPE_PHYSICAL)));

      if best_target.unit:GetHealth() - time * idps * 0.75 > best_target.unit:GetActualDamage(bot:GetBaseDamage(), DAMAGE_TYPE_PHYSICAL) * 0.95 then
        print("Cancelling attack");
        bot:Action_ClearActions(true);
      else
        print("Finishing attack");
      end
    end

    coroutine_helpers.wait_until(function()
	    print("Waiting to finish attack: " .. tostring(bot:GetCurrentActionType() == BOT_ACTION_TYPE_ATTACK));
	    return bot:GetCurrentActionType() ~= BOT_ACTION_TYPE_ATTACK;
    end);

  else
    print("No potential targets");
  end

end

local module = {};
module.Think = function()

  --TEMP: Send all bots back to fountain and leave them idling
  if bot:GetPlayer() ~= 4 then
    bot:Action_MoveToLocation(GetLocationAlongLane(LANE_MID, 0));
    return;
  end

  --Try to level abilities
  TryToLevel(bot);

  --Reset back to start state if we're dead
  if not bot:IsAlive() then
    print("Bot is dead, considering buyback");
    co = nil;

    --todo: Consider buyback
    bot:Action_Buyback(); --temp!

    --Can't do anything else :(
    return;
  end

  --Create a coroutine to run the main bot logic
  if not co then
    print("Creating primary coroutine");
    co = coroutine.create(main_co);
  end

  --Run the coroutine and null it out once it finishes
  local status, err = coroutine.resume(co);
  if err then
    print("Main coroutine err: " .. err);
  end
  if coroutine.status(co) == "dead" then
    print("Completed main coroutine");
    co = nil;
  end
end

return module;
