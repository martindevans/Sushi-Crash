
local moved_to_shrine = false;

function Think()

  local bot = GetBot();

  --Reset back to start state if we're dead
  if not bot:IsAlive() then
    moved_to_shrine = false;
    return;
  end

  --Are we channeling an ability (e.g. a teleport). If so just don't think (average dota2 player *rimshot*)
  if bot:IsChanneling() then
    return;
  end

  --Let's try to get to the shrine
  if not moved_to_shrine then

    --assume TP is in slot 0, if the slot is empty then buy a TP
    local item0 = bot:GetItemInSlot(0);
    if not item0 then
      local gold = bot:GetGold() > 200;
      local tp_buy = bot:Action_PurchaseItem("item_tpscroll");
      local purchase = gold and tp_buy == PURCHASE_ITEM_SUCCESS;
      item0 = bot:GetItemInSlot(0);
    end

    --Try to TP to shrine
    if item0 and item0:GetName() == "item_tpscroll" then

      --Wait for TP cooldown
      if item0:GetCooldownTimeRemaining() > 0 then
        return;
      end

      print("Teleporting (" .. bot:GetUnitName() .. ")");
      bot:Action_UseAbilityOnLocation(item0, Vector(636.337952, -2703.370117, 384.000000));
    end

    moved_to_shrine = true;
    return;
  end

  --Find a nearby target to kill
  local target = bot:GetAttackTarget();
  local attacking = target and target:IsAlive();
  if not attacking then
    local enemies = bot:GetNearbyHeroes(500, true, 1);
    for i, v in pairs(enemies) do
      bot:Action_AttackUnit(v, false);
      attacking = true;
      break;
    end
  end

  --still no target, go back to the shrine
  if not attacking then
    bot:Action_MoveToLocation(Vector(636.337952, -2703.370117, 384.000000));
  end

end
