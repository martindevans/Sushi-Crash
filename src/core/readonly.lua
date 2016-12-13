--Make the given table readonly
local function readonly(t)
  assert(type(t) == "table");

  return setmetatable({}, {

    --Reading from this table refers back to t
    __index = t,

    --Writing to this table throws an error
    __newindex = function(table, key, value)
      error("Attempt to modify read-only table")
    end,

    --Removing the metatable method prevents anyone else doing any meta trickery with this table
    __metatable = false

   });
end

test("Return is readonly", function()
  local t = { hello = "world" };
  local r = readonly(t);

  --This should throw!
  expect_error(function()
    r.hello = ", world";
  end);
end)

test("Cannot make non-table readonly", function()
  expect_error(function()
    readonly(1);
  end)
end);

test("Can read from readonly table", function()
  local t = { hello = "world" };
  local r = readonly(t);

  assert(t.hello == "world");
end);

test("Can mutate underlying table", function()
  local t = { hello = "world" };
  local r = readonly(t);

  t.hello = "せかい";

  assert(t.hello == "せかい");
end);

test("Cannot set metatable of readonly", function()
  local t = { hello = "world" };
  local r = readonly(t);

  expect_error(function()
    setmetatable(r, {});
  end);
end)

return readonly;
