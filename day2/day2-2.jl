global const currDIR::String = @__DIR__

function run()
    @time val = invalidIDs("$currDIR/day2.txt")
    if val == 33832678380
        print("✓ Test Passed: $val == 33832678380\n")
    else
        print("X Test Failed: $val != 33832678380\n")
    end
    return nothing
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

    for range in rangeVec
        for i in range
            stri = string(i)
            if isrepeating(stri)
                runTotal += i
            end           
        end
    end

    return runTotal
    
end

function isrepeating(str::String)
    tf::Bool = false
    leng::Int = length(str)

    facVec::Vector{Int} = findFactors(leng)

    for i in facVec
        if isrepeatingN(str,i) == true
            tf = true
            break
        end
    end

    return tf
end

function isrepeatingN(str::String,N::Int)
    tf::Bool = false
    len::Int = length(str)
    repNum::Int = len ÷ N
    compStr::String = ""
    for i = 1:repNum
        if i == 1
            compStr = str[1:N]
        else
            if compStr == str[Int((i-1)*N+1):Int(i*N)]
                if i == repNum
                    tf = true
                    break
                end
                continue
            else
                tf = false
                break
            end
        end
    end
    return tf
end

function findFactors(x::Int)
    facVec::Vector{Int} = []
    for i = 1:x
        if x%i == 0
            push!(facVec,i)
        end
    end
    return facVec
end

run()