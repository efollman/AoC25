global const DIR::String = "$(@__DIR__)/day8.txt"

struct point
    x::UInt
    y::UInt
    z::UInt
end

function run()
    @time val = last2(DIR)
    shouldbe = 107256172
    if val == shouldbe
        print("✓ Test Passed: $val == $shouldbe\n")
    else
        print("X Test Failed: $val != $shouldbe\n")
    end
    return nothing
end

function parsePoints(filepath::String)
    currLine::Vector{String} = fill("",3)
    currLineN::Vector{UInt} = fill(0,3)
    points::Vector{point} = []
    open(filepath) do file
        while !eof(file)
            currLine = split(readline(file),",")
            for i in eachindex(currLine)
                currLineN[i]= parse(UInt,currLine[i])
            end
            push!(points,point(currLineN[1],currLineN[2],currLineN[3]))
        end
    end
    return points
end

function distanceMatrix(filepath::String)
    v::Vector{point} = Vector{point}(parsePoints(filepath))
    distanceMatrix::Matrix{UInt} = fill(typemax(UInt64),length(v),length(v))


    currDistSq::UInt = 0
    

    for i in eachindex(v)
        for i2 in eachindex(v)
            if i2 >= i
                    continue 
            end
            currDistSq = (v[i].x-v[i2].x)^2 + (v[i].y-v[i2].y)^2 + (v[i].z-v[i2].z)^2
            distanceMatrix[i,i2] = currDistSq
        end
    end



    return distanceMatrix, v
end

function connectPoints(filepath::String)
    dM::Matrix{UInt},pointVec::Vector{point} = distanceMatrix(filepath)
    circuits::Vector{Vector{UInt}} = Vector{Vector{UInt}}[]
    nextlowest::CartesianIndex = CartesianIndex(0,0)
    circuitN::UInt = 0
    circuitN2::UInt = 0
    n::UInt = 1
    last2boxes::Tuple{point,point} = (point(0,0,0),point(0,0,0))

    while true
        nextlowest = argmin(dM)
        dM[nextlowest] = typemax(UInt64)
        circuitN, _ = checkCircuitLoc(circuits,UInt(nextlowest[1]))
        circuitN2, _ = checkCircuitLoc(circuits,UInt(nextlowest[2]))
        if circuitN == 0 && circuitN2 == 0
            push!(circuits,[nextlowest[1],nextlowest[2]])
        else
            if circuitN == 0
                push!(circuits[circuitN2],nextlowest[1])
            elseif circuitN2 == 0
                push!(circuits[circuitN],nextlowest[2])
            elseif circuitN < circuitN2
                for point in circuits[circuitN2]
                    push!(circuits[circuitN],point) ##appending vectors together somehow is likely faster
                end
                deleteat!(circuits,circuitN2)
            elseif circuitN2 < circuitN
                for point in circuits[circuitN]
                    push!(circuits[circuitN2],point) ##appending vectors together somehow is likely faster
                end
                deleteat!(circuits,circuitN)
            elseif circuitN == circuitN2
            else
                @error "Unexpected logic in paring ciruits"
            end
            
        end
        circuitN = 0
        circuitN2 = 0
        n += 1
        if length(circuits) == 1 && length(circuits[1]) == size(dM,1)
            last2boxes = (pointVec[nextlowest[1]],pointVec[nextlowest[2]])
            break
        end
    end

    return last2boxes

end

function checkCircuitLoc(c::Vector{Vector{UInt}},iIn::UInt)
    i::UInt = 0
    i2::UInt = 0
    iOut::UInt = 0
    i2Out::UInt = 0
    flag::Bool = false
    for i = eachindex(c)
        for i2 = eachindex(c[i])
            if c[i][i2] == iIn
                iOut = i
                i2Out = i2
                flag = true
                break
            end
        end
        if flag == true break end
    end
    return iOut, i2Out
end

function last2(filepath::String)
    last2boxes::Tuple{point,point} = connectPoints(filepath)
    multX = prod([last2boxes[1].x,last2boxes[2].x])
    return multX
end

run()