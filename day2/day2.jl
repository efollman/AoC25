global const currDIR::String = @__DIR__

function run()
    val = invalidIDs("$currDIR/day2.txt")
    return val
end

function invalidIDs(filepath::String)
    rangeString::String = ""
    open(filepath) do file
        while !eof(file)
            rangeString = rangeString * readline(file)
        end
    end

    stringVec::Vector{String} = split(rangeString,",")
    rangeVec::Vector{UnitRange{Int}} = []
    currValuesStr::Vector{String} = ["",""]
    currValuesInt::Vector{Int} = [0,0]

    for str in stringVec
        currValuesStr = split(str,"-")
        for i = 1:2
            currValuesInt[i] = parse(Int,currValuesStr[i])
        end

        push!(rangeVec,(currValuesInt[1]:currValuesInt[2]))
    end

    stri::String = ""
    runTotal::Int = 0
    strleng::Int = 0
    midpoint::Int = 0

    for range in rangeVec
        for i in range
            stri = string(i)
            if !iseven(length(stri))
                continue
            else
                strleng = length(stri)
                midpoint = Int(strleng/2)
                if stri[1:midpoint] == stri[midpoint+1:end]
                    runTotal += i
                end
            end
        end
    end

    return runTotal
    
end

val = run()