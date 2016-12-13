local state = 0;

function Think()
    if state == 0 then
        for k, _ in pairs(_G) do
            print(k);
        end
    end
    
    state = state + 1;
end