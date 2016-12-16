--[[

  -- Runs child nodes in sequence. Succeeds if final node succeeds, fails (as soon as any node cancels)

]]

local state = require("src/behaviour_tree/node_state");
local readonly = require("src/core/readonly");

local module = {};

function module.new(...)

  local next_index = 1;
  local nodes = { ... };

  local obj = {};

  --Set the start state to ready
  obj.State = state.Ready;

  --Write the predicate result into state
  obj.Visit = function()

    if obj.State == state.Ready then
      obj.State = state.Running;
    elseif obj.State ~= state.Running then
      return;
    end

    --if we've run off the end we're done (successfully)
    if next_index > #nodes then
      obj.State = state.Success;
      return;
    end

    --Determine which node to run next...
    local next = nodes[next_index];

    --...and run it
    next.Visit();

    --Determine how our own state changes
    if next.State == state.Failed or next.State == state.Error then
      --bubble up error states
      obj.State = next.State;
    elseif next.State == state.Success then
      next_index = next_index + 1;
    end
  end

  --Reset back to ready state
  obj.Reset = function()
    error("Not implemented");
  end

  obj.Cancel = function()
    error("Not implemented");
  end

  return readonly(obj);
end

if test then
  test("Starts in ready state", function()
    local n = module.new();

    assert(n.State == state.Ready, "Expected ready state");
  end);

  test("State is readonly", function()
    local n = module.new();

    expect_error(function()
      n.State = "Hello";
    end)
  end);

  test("Empty sequence succeeds", function()
    local n = module.new();

    n.Visit();

    assert(n.State == state.Success, "Expected success");
  end);

  test("Single child node succeeds", function()
    local n = module.new({
      State = state.Success,
      Visit = function() end
    });

    --Once to run the child, once again to succeed
    n.Visit();
    n.Visit();

    assert(n.State == state.Success, "Expected success");
  end);

  test("Single child node fails", function()
    local n = module.new({
      State = state.Failed,
      Visit = function() end
    });

    n.Visit();

    assert(n.State == state.Failed, "Expected failure");
  end);

  test("Failing node prevents next node from ever running", function()

    local it_was_visited = false;

    local n = module.new({
      State = state.Failed,
      Visit = function() end
    }, {
      State = state.Success,
      Visit = function() it_was_visited = true end
    });

    --Doesn't matter how many times we visit, we'll never visit the second node
    n.Visit();
    n.Visit();
    n.Visit();
    n.Visit();
    n.Visit();

    assert(not it_was_visited, "second node was visited");
  end);

end

return module;
