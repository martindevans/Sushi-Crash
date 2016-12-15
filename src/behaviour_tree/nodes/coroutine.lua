--[[

  - A node which runs a coroutine when visited. Once the coroutine is started it will be resumed every time the node is visited again until the
    co-routine finishes.
  - To indicate that the co-routine is being cancelled the co-routine will be resumed (once) with a "true" value. All calls to yield should watch
    this value and handle cancellation as appropriate.
  - To indicate failure the co-routine should return an explicit false value (all other return values, including nil indicate nothing which defaults
    to success).

]]

local state = require("src/behaviour_tree/node_state");
local readonly = require("src/core/readonly");

local module = {};

function module.new(func)
  assert(type(func) == "function");

  local thread = nil;
  local obj = {};

  local function run_once(resume_flag)
    if not thread then
      return;
    end

    local status = coroutine.status(thread);
    if status == "suspended" then
      local ok, result = coroutine.resume(thread, resume_flag);

      if ok then
        --thread ran ok! Did we finish yet?
        if coroutine.status(thread) == "dead" then
          if result == nil or result then
            obj.State = state.Success;
            thread = nil;
          else
            obj.State = state.Failed;
            thread = nil;
          end
        else
          obj.State = state.Running;
        end
      else
        obj.State = state.Error;
        thread = nil;
      end
    end
  end

  --Set the start state to ready
  obj.State = state.Ready;

  --Write the predicate result into state
  obj.Visit = function()
    run_once(false);
  end

  --Reset back to ready state
  obj.Reset = function()
    --Create a new thread out of the function
    thread = coroutine.create(func);

    obj.State = state.Ready;
  end

  --Cancel the co-routine
  obj.Cancel = function()
    run_once(true);
  end

  obj.Reset();
  return readonly(obj);
end

if test then
  test("Starts in ready state", function()
    local n = module.new(function() end);

    assert(n.State == state.Ready, "Expected node to be ready");
  end);

  test("State is readonly", function()
    local n = module.new(function() end);

    expect_error(function()
      n.State = "Hello";
    end)
  end);

  test("Visiting with non-yield routine leads to success", function()
    local n = module.new(function() end);

    n.Visit();
    assert(n.State == state.Success, "Expected node to succeed - " .. tostring(n.State));
  end);

  test("Visiting with non-yield erroring routine leads to error", function()
    local n = module.new(function() return error("oh no!"); end);

    n.Visit();
    assert(n.State == state.Error, "Expected node to error");
  end);

  test("Visiting with yield routine leads to running and then success", function()
    local n = module.new(function()
      coroutine.yield();
    end);

    n.Visit();
    assert(n.State == state.Running, "Expected node to still be running");

    n.Visit();
    assert(n.State == state.Success, "Expected node to succeed");
  end);

  test("Yield false leads to failure", function()
    local n = module.new(function()
      return false;
    end);

    n.Visit();
    assert(n.State == state.Failed, "Expected node to succeed");
  end);

  test("Cancellation passes true to co-routine", function()

    --Create a coroutine which yields the flag passes to it. We can infer this value from the success/failure state
    local n = module.new(function()
      return not coroutine.yield();
    end);

    --Need to run this twice (once to pass in the value, second time to return it)
    n.Visit();
    n.Visit();

    --We visited the co-routine normally, so it should have passed false. Which is inverted to true (i.e. success)
    assert(n.State == state.Success, n.State);
  end);

  test("Cancellation passes true to co-routine", function()

    --Create a coroutine which yields the flag passes to it. We can infer this value from the success/failure state
    local n = module.new(function()
      return not coroutine.yield();
    end);

    --Need to run this twice (once to pass in the value, second time to return it)
    n.Cancel();
    n.Visit();

    --We visited the co-routine normally, so it should have passed false. Which is inverted to true (i.e. success)
    assert(n.State == state.Success, n.State);
  end);
end

return module;
