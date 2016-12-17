local printed = false;

function Think()
  print(tostring(RealTime()));

  if not printed then
  end
  printed = true;
end

function dump_table(t)
  for k, v in pairs(t) do
    print(k .. " : " .. type(v));
  end
end

if test then
  test("Playground", function()
    print(tostring(getArgs(test)));
    error("Oh no!");
  end)
end
