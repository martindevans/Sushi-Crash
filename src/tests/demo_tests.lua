a = "state!";

test("demo1", function()
  a = "muahaha interdependent tests"

  assert(1 == 1, "You will never see this message!");
end);

test("demo2", function()
  --gotcha, states all get a completely clean version of the environment (as if no other test has run yet)
  assert(a == "state!", a);

  --It's annoying to have this test always fail so I've commented out this assert which (obviously) fails
  --assert(1 == 2, "You will always see this message!");
end);

test("demo3", function()
end);

test("demo4", function()
end);
