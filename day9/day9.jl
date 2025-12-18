global const DIR::String = "$(@__DIR__)/day9.txt"

function run()
    @time val = maxRectangle(DIR)
    shouldbe = 4777816465
    if val == shouldbe
        print("✓ Test Passed: $val == $shouldbe\n")
    else
        print("X Test Failed: $val != $shouldbe\n")
    end
    return nothing
end

function parsePoints(filepath::String)
    currLine::Vector{String} = fill("",2)
    currLineN::Vector{UInt} = fill(0,2)
    points::Matrix{UInt} = [0 0]

    open(filepath) do file
        firstL::Bool = true
        while !eof(file)
            currLine = split(readline(file),",")
            for i in eachindex(currLine)
                currLineN[i]= parse(UInt,currLine[i])
            end
            if firstL == true
                points[1,:] = currLineN
                firstL = false
            else
                points = vcat(points,transpose(currLineN))
            end
        end
    end
    return points
end

function recArea(point1::Vector{UInt},point2::Vector{UInt})
    l1::UInt = UInt(abs(Int(point1[1])-Int(point2[1]))+1)
    l2::UInt = UInt(abs(Int(point1[2])-Int(point2[2]))+1)
    A::UInt = l1*l2
    return A
end

function maxRectangle(filepath::String)
    points::Matrix{UInt} = parsePoints(filepath)
    maxArea::UInt = 0
    currArea::UInt = 0
    ##Assume clockwise loop from reading first few points
    #Test Points i,i+1,i+2 (withMod) to see if made rectangle would be green, already verified points are corner only
    for i in 1:size(points,1)
        for j in (i+1):size(points,1)
            currArea = recArea(points[i,:],points[j,:])
            if currArea > maxArea
                maxArea = currArea
            end
        end
    end

    return maxArea
end
run()

