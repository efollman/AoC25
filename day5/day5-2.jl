global const currDIR::String = @__DIR__

function run()
    @time val = freshNum("$currDIR/day5.txt")
    shouldbe = 347338785050515
    if val == shouldbe
        print("✓ Test Passed: $val == $shouldbe\n")
    else
        print("X Test Failed: $val != $shouldbe\n")
    end
    return nothing
end

function freshNum(filepath::String)
    freshIDs::Vector{UnitRange{UInt64}} = []
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
                break
            else
                @error "Parsed Too Far"
            end

        end
    end

    freshN::UInt = 0
    length1::UInt = 0
    length2::UInt = 0
    flag::Bool = false
    loc1::UInt = 0
    loc2::UInt = 0
    combRange::UnitRange{UInt64} = 0:0
    
    #Not sure how i feel about this combining ranges loop but it runs very fast so that is encouraging. It is definitley janky though.
    while true
        length1 = length(freshIDs)
        flag = false


        for i in eachindex(freshIDs)
            for j in eachindex(freshIDs)
                if j == i continue end

                if !isempty(intersect(freshIDs[i],freshIDs[j]))
                    loc1 = i
                    loc2 = j
                    flag = true
                    break
                end
            end
            if flag == true break end
        end

        if flag == true
            combRange = combineRanges(freshIDs[loc1],freshIDs[loc2])
            deleteat!(freshIDs,maximum([loc1,loc2]))
            deleteat!(freshIDs,minimum([loc1,loc2]))
            push!(freshIDs,combRange)
        end



        length2 = length(freshIDs)
        if length1 == length2
            break
        end
    end

    for range in freshIDs
        freshN += length(range)
    end

    return freshN

end

function combineRanges(range1,range2)

    min = minimum([minimum(range1),minimum(range2)])
    max = maximum([maximum(range1),maximum(range2)])

    range::UnitRange{UInt64} = min:max

    return range
end

run()