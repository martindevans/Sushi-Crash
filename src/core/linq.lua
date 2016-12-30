local module = {};

--Set of functions which can be run on an enumerable. These are lazily attached to an enumerator instance when you call them
local extensions = {

    --Take all values which pass the given predicate (filter)
    where = function(t)
        return function(predicate)
            return module.from_generator(function(yield)
                while t.move_next() do
                    local n = t.current()
                    if n == nil then
                        break
                    end
                    if (predicate(n)) then
                        yield(n)
                    end
                end
            end)
        end
    end,

    --apply a function to all values to produce a new one (map)
    select = function(t)
        return function(mutation)
            return module.from_generator(function(yield)
                local index = 1;
                while t.move_next() do
                    local current = t.current();
                    yield(mutation(current, index));
                    index = index + 1;
                end
            end)
        end
    end,

    --Split the sequence in two parts with a predicate. Before the predicate is true run before (or do nothing if it is nil). After the predicate is true run after (or immediately exit if it is nil).
    partition = function(t)
        return function(predicate, before, after)
            return module.from_generator(function(yield)
                local index = 1;
                local pred = true;
                while t.move_next() do
                    if pred then
                        pred = predicate(t.current(), index);
                    end

                    if pred then
                        if before and before(yield, t.current(), index) then
                            break;
                        end
                    else
                        if not after or after(yield, t.current(), index) then
                            break;
                        end
                        
                    end
                    index = index + 1;
                end
            end)
        end
    end,

    skip_while = function(t)
        return function(predicate)
            return t.partition(predicate, nil, function(yield, current) yield(t.current()); end);
        end
    end,

    skip = function(t)
        return function(count)
            return t.skip_while(function(current, index)
                return index <= count;
            end);
        end
    end,

    take_while = function(t)
        return function(predicate)
            return t.partition(predicate, function(yield, current) yield(current); end);
        end
    end,

    take = function(t)
        return function(count)
            return t.take_while(function(current, index)
                return index <= count;
            end);
        end
    end,

    aggregate = function(t)
        return function(seed, aggregator)
            local aggregated = seed;
            local firstIteration = true;

            while t.move_next() do
                aggregated = aggregator(aggregated, t.current());
            end

            return aggregated;
        end
    end,

    count = function(t)
        return function()
            local counter = 0
            while t.move_next() do
                counter = counter + 1
            end
            return counter
        end
    end,

    to_array = function(t)
        return function(iterationCallback)
            local l = {}
            while t.move_next() do
                table.insert(l, t.current())
                if iterationCallback ~= nil then
                    iterationCallback()
                end
            end
            return l;
        end
    end
}

module.from_generator = function(generator)
local t = {}
	local mt = {}
	setmetatable(t, mt)

	local wrappedGenerator = coroutine.wrap(generator, coroutine.yield)
	local iterate = function()
		return wrappedGenerator(coroutine.yield)
	end

	local started = false
	local current = nil

    --If you call the table it will move to the next value. This makes it act like a lua generator function
    mt.__call = function()
		if t.move_next() then
			return t.current()
		else
			return nil
		end
	end

    --If you try to access a value on the table which doesn't exist it falls back here
    --If it's one of the known values, run the function and return that value as the value
    mt.__index = function(tbl, key)

        --Check that we're not doing anything with an enuemration which has already started (someone forgot to call .clone() on a shared enumerator)
        if started then
            error("Cannot access a query extensions after enumeration has already started");
        end

        local ext = extensions[key];
        if ext then
            local func = ext(tbl);
            tbl[key] = func;
            return func;
        end

        return nil;
    end

    t.clone = function()
        return module.from_generator(generator);
    end

    --Get the current value of the enumerator
	t.current = function()
        assert(started, "Cannot get value of an enumeration before it begins")
		return current;
	end

    --Move to the next value
	t.move_next = function()
		started = true;
		current = iterate();
		return current ~= nil
	end

	return t
end

module.from_array = function(arr)
    assert(type(arr) == "table", "Expected a table");

    return module.from_generator(function(yield)
		for k, v in ipairs(arr) do
			yield(v)
		end
	end);
end

if test then
    test("Shared enumerator access", function()
        local enumerator = module.from_array({ 3, 7, 2, 1, 9, 11 });

        local lt4 = enumerator.clone().where(function(a) return a < 4; end).to_array();
        local gt4 = enumerator.clone().where(function(a) return a > 4; end).to_array();

        assert(lt4[1] == 3);
        assert(lt4[2] == 2);
        assert(lt4[3] == 1);
        assert(#lt4 == 3);

        assert(gt4[1] == 7);
        assert(gt4[2] == 9);
        assert(gt4[3] == 11);
        assert(#gt4 == 3);
    end);

    test("Cannot extend enuemration after it is started", function()
        local enumerator = module.from_array({ 3, 7, 2, 1, 9, 11 });

        --Started the enumeration
        enumerator.move_next();

        expect_error(function()
            enumerator.where(function(a) return a > 4; end);
        end);
    end);

    test("array enumerator contains all values", function()
        local enumerator = module.from_array({ 3, 7, 2, 1, 9, 11 });

        assert(enumerator() == 3);
        assert(enumerator() == 7);
        assert(enumerator() == 2);
        assert(enumerator() == 1);
        assert(enumerator() == 9);
        assert(enumerator() == 11);
        assert(enumerator() == nil);
    end);

    test("to_array contains all input values", function()
        local arr = module.from_array({ 3, 7, 2, 1, 9, 11 }).to_array();

        assert(arr[1] == 3);
        assert(arr[2] == 7);
        assert(arr[3] == 2);
        assert(arr[4] == 1);
        assert(arr[5] == 9);
        assert(arr[6] == 11);
    end);

    test("count is count of items in input", function()
        local enumerator = module.from_array({ 3, 7, 2, 1, 9, 11 });

        assert(enumerator.count() == 6);
    end);

    test("take takes given number of items", function()
        local enumerator = module.from_array({ 3, 7, 2, 1, 9, 11 });
        local taken = enumerator.take(3).to_array();

        assert(taken[1] == 3);
        assert(taken[2] == 7);
        assert(taken[3] == 2);
        assert(#taken == 3);
    end);

    test("take returns nils after input is over", function()
        local enumerator = module.from_array({ 3, 7, 2, 1, 9, 11 });
        local taken = enumerator.take(7).to_array();

        assert(taken[1] == 3);
        assert(taken[2] == 7);
        assert(taken[3] == 2);
        assert(taken[4] == 1);
        assert(taken[5] == 9);
        assert(taken[6] == 11);
        assert(taken[7] == nil);
        assert(#taken == 6);
    end);

    test("take_while takes values until predicate is false", function()
        local enumerator = module.from_array({ 3, 7, 2, 1, 9, 11 });
        local taken = enumerator.take_while(function(v) return v > 1 end).to_array();

        assert(taken[1] == 3);
        assert(taken[2] == 7);
        assert(taken[3] == 2);
        assert(taken[4] == nil);
    end);

    test("skip skips count items", function()
        local enumerator = module.from_array({ 3, 7, 2, 1, 9, 11 });
        local taken = enumerator.skip(3).to_array();

        assert(taken[1] == 1);
        assert(taken[2] == 9);
        assert(taken[3] == 11);
        assert(taken[4] == nil);
    end);

    test("skip_while skips values until predicate is false", function()
        local enumerator = module.from_array({ 3, 7, 2, 1, 9, 11 });
        local taken = enumerator.skip_while(function(v) return v > 1 end).to_array();

        assert(taken[1] == 1);
        assert(taken[2] == 9);
        assert(taken[3] == 11);
        assert(taken[4] == nil);
    end);

    test("aggregate aggregates values", function()
        local enumerator = module.from_array({ 3, 7, 2, 1, 9, 11 });
        local sum = enumerator.aggregate(0, function(a, b) return a + b end);

        assert(sum == 33);
    end);

    test("select maps values", function()
        local arr = module.from_array({ 3, 7, 2, 1, 9, 11 })
            .select(function(a) return a + 1 end)
            .to_array();

        assert(arr[1] == 4);
        assert(arr[2] == 8);
        assert(arr[3] == 3);
        assert(arr[4] == 2);
        assert(arr[5] == 10);
        assert(arr[6] == 12);
        assert(arr[7] == nil);
    end);

    test("where filters values", function()
        local arr = module.from_array({ 3, 7, 2, 1, 9, 11 })
            .where(function(a) return a > 3 end)
            .to_array();

        assert(arr[1] == 7);
        assert(arr[2] == 9);
        assert(arr[3] == 11);
        assert(arr[4] == nil);
    end);
end

return module;