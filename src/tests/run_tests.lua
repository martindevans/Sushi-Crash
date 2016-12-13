--List of all test files (relative to whatever directory you run this from, which is assumed to be the root of the repo)
local test_files = assert(loadfile("src/tests/manifest.lua"))();

local function expect_error(fun)
  --Run "fun" and throw an error if it does *not* throw an error
  local ret, err = pcall(fun);

  if not err then
    error("Expected function to error, instead return result: '" .. tostring(ret) .. "'");
  end
end

local function run_test_file(path)
  local loaded, load_err = loadfile(path);
  if load_err then
    print("CRIT - Loading file '" .. path .. "' encountered error '" .. load_err .. "'");
    return;
  end

  local ran = 0;
  local fail = 0;
  local pass = 0;

  local a_test_ran = false;
  local next_test_index = 0;
  repeat
    --Keep track of the index of the test we're going to run next
    local test_index = 0;

    --Create a new environment with a "test" function which will run a single test this iteration
    local env = nil;
    env = setmetatable({
      a_test_ran = false,

      expect_error = expect_error,

      test = function(label, func)

        if test_index == next_test_index then
          env.a_test_ran = true;

          local _, err = pcall(func);
          if err then
            env.test_passed = false;
            print("FAIL - " .. err);
          else
            env.test_passed = true;
          end
        end
        test_index = test_index + 1;

      end
    }, { __index=_G });

    --Run the file in the scope we just created
    local status, run_err = pcall(setfenv(loaded, env));
    if not status then
      print("CRIT - Running test file '" .. path .. "' encountered error '" .. run_err .. "'");
      return;
    end

    --Update the counter so the next test will run next time
    next_test_index = next_test_index + 1;

    --The test ran in a scope (env) and set the 'a_test_ran' field *inside that scope*. Extract it now
    a_test_ran = env.a_test_ran;
    if a_test_ran then
      ran = ran + 1;
      if env.test_passed then
        pass = pass + 1;
      else
        fail = fail + 1;
      end
    end

  until not a_test_ran;

  return ran, pass, fail;

end

print("Running tests from " .. #test_files .. " files...");
local p = print;
_G.print = function(s) p(" | " .. s); end;
print("");
local start = os.time();

--Run all the files
local count = 0;
local pass = 0;
local fail = 0;
for _, path in ipairs(test_files) do
  print("Testing " .. path);

  local r, p, f = run_test_file(path);

  count = count + r;
  pass = pass + p;
  fail = fail + f;

  print(" - Done (" .. tostring(r) .. ")")
end

local duration = os.time() - start;
print("");
_G.print = p;
print("Ran " .. count .. " tests (" .. fail .. " failed) in " .. duration .. "s");
