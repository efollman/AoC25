global const currDIR::String = @__DIR__

function run()
    @time val = freshNum("$currDIR/day5.txt")
    shouldbe = 520
    if val == shouldbe
        print("✓ Test Passed: $val == $shouldbe\n")
    else
        print("X Test Failed: $val != $shouldbe\n")
    end
    return nothing
end

function freshNum(filepath::String)
    freshIDs::Vector{UnitRange{UInt64}} = []
    availIDs::Vector{UInt64} = []
    open(filepath) do file
        currLine::String = ""
        rangeStart::String = ""
        rangeEnd::String = ""
        while !eof(file)
            currLine = readline(file)
            if contains(currLine,"-")
                rangeStart,rangeEnd = split(currLine,"-")
                push!(freshIDs,UnitRange{UInt64}(parse(UInt64,rangeStart):parse(UInt64,rangeEnd)))
            elseif isempty(currLine)
                continue
            else
                push!(availIDs,parse(UInt64,currLine))
            end

        end
    end

    freshN::UInt = 0
    for ID in availIDs
        for range in freshIDs
            if in(ID,range)
                freshN += 1
                break
            end
        end
    end

    
    return freshN

end

run()