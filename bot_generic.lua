
local moved_to_shrine = false;

function Think()

  local bot = GetBot();

  if not bot:IsAlive() then
    moved_to_shrine = false;
    return;
  end

  if not moved_to_shrine then

    local item0 = bot:GetItemInSlot(0);

    local gold = bot:GetGold() > 200;
    local tp_buy = bot:Action_PurchaseItem("item_tpscroll");
    local purchase = gold and tp_buy == PURCHASE_ITEM_SUCCESS;

    if gold and purchase then
      --Use the TP scroll to get the the shrine instead of walking there
    else
      bot:Action_MoveToLocation(Vector(636.337952, -2703.370117, 384.000000));
    end
    moved_to_shrine = true;
  end

  local target = bot:GetAttackTarget();
  if not target or not target:IsAlive()  then
    local enemies = bot:GetNearbyHeroes(500, true, 1);
    for i, v in pairs(enemies) do
      bot:Action_AttackUnit(v, false);
      break;
    end
  end

end
