function day9()

    function run()
        println("Running day9:")
        @time val = maxRectangle("$inputDIR/day9.txt")
        shouldbe = 1410501884
        if val == shouldbe
            print("✓ Test Passed: $val == $shouldbe\n")
        else
            print("X Test Failed: $val != $shouldbe\n")
        end
        println()
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

    function compressPoints(points::Matrix{UInt})
        xD::Dict{UInt,UInt} = Dict()
        yD::Dict{UInt,UInt} = Dict()
        xV::Vector{UInt} = points[:,1]
        yV::Vector{UInt} = points[:,2]
        sort!(xV)
        sort!(yV)
        n::UInt = 1
        for i::UInt in eachindex(xV)
            if i == 1
                xD[xV[i]] = n
                n += 1
            elseif xV[i-1] == xV[i]
                continue
            else
                xD[xV[i]] = n
                n += 1
            end
        end
        n = 1
        for i::UInt in eachindex(yV)
            if i == 1
                yD[yV[i]] = n
                n += 1
            elseif yV[i-1] == yV[i]
                continue
            else
                yD[yV[i]] = n
                n += 1
            end
        end
        compPoints::Matrix{UInt} = copy(points)
        for i::UInt in eachindex(compPoints[:,1])
            compPoints[i,1] = xD[points[i,1]]
        end
        for i::UInt in eachindex(compPoints[:,2])
            compPoints[i,2] = yD[points[i,2]]
        end
        return compPoints, xD, yD
    end

    function createBooleanMat(points::Matrix{UInt})
        xsize::UInt = maximum(points[:,1])
        ysize::UInt = maximum(points[:,1])
        boolMat::Matrix{Bool} = fill(false,xsize,ysize)
        i2::UInt = 0
        for i::UInt in eachindex(points[:,1])
            if i == size(points,1)
                i2 = UInt(1)
            else
                i2 = i+1
            end
            if points[i,2] == points[i2,2]
                if points[i,1] < points[i2,1]
                    boolMat[points[i,1]:Int64(points[i2,1]),Int64(points[i,2])] .= true
                elseif points[i,1] > points[i2,1]
                    boolMat[points[i2,1]:Int64(points[i,1]),Int64(points[i,2])] .= true
                end
            elseif points[i,1] == points[i2,1]
                if points[i,2] < points[i2,2]
                    boolMat[points[i,1],Int64(points[i,2]):Int64(points[i2,2])] .= true
                elseif points[i,2] > points[i2,2]
                    #boolMat[points[i,1],points[i2,2]:points[i,2]] .= true #There is an error here and i cannot for the life of me figure this out
                    boolMat[points[i,1],Int64(points[i2,2]):Int64(points[i,2])] .= true #Goofy language bug lol ahah
                end
            end
        end

        boolMatFill::Matrix{Bool} = fill(false,size(boolMat,1),size(boolMat,2))

        function boundaryFill(x::Int,y::Int) #This only works because the area withing the shape is continuous and boundry never touches itself could maybe be fixed by spacing out compressed points by 2 to gaurantee this
            if boolMat[x, y] != true && boolMatFill[x, y] != true
                boolMatFill[x,y] = true
                boundaryFill(x + 1, y)
                boundaryFill(x, y + 1)
                boundaryFill(x - 1, y)
                boundaryFill(x, y - 1)
            end
            return nothing
        end

        boundaryFill(100,100) #determined based on chart of compressed points won't work for example data could random seed and determine which is right by comparing the two different outputs on the edge, would be very slow though
                                #Alternatively could somehow test if rec crosses the boundary for faster and easier result removing the necessity of shape fill.
                                # wait a minute, if there is any trues other than the perimiter of the rectangle would tell you its not within green
                                #this shouldnt have edge case either as some of the inner shape is garanteed to be within the rectangle?
        for i in eachindex(boolMat)
            if boolMat[i] == true
                boolMatFill[i] = true
            end
        end

        return boolMatFill, boolMat
    end

    
    function isGreen(p1::Vector{UInt},p2::Vector{UInt},boolMat::Matrix{Bool},xD::Dict{UInt,UInt},yD::Dict{UInt,UInt})
        x1::UInt = xD[minimum([p1[1],p2[1]])]
        y1::UInt = yD[minimum([p1[2],p2[2]])]
        x2::UInt = xD[maximum([p1[1],p2[1]])]
        y2::UInt = yD[maximum([p1[2],p2[2]])]

        return all(boolMat[x1:x2,y1:y2] .== true)

    end

    function isGreen2(p1::Vector{UInt},p2::Vector{UInt},boolMatperim::Matrix{Bool},xD::Dict{UInt,UInt},yD::Dict{UInt,UInt})
            #Alternatively could somehow test if rec crosses the boundary for faster and easier result removing the necessity of shape fill.
                                # wait a minute, if there is any trues other than the perimiter of the rectangle would tell you its not within green
                                #this shouldnt have edge case either as some of the inner shape is garanteed to be within the rectangle?
                                #only edge case would be a rectangle with no inner area, this would actually cause issues in this case test if all true?
                                #=

                                =#
    end

    function maxRectangle(filepath::String)
        points::Matrix{UInt} = parsePoints(filepath)
        compPoints::Matrix{UInt}, xD::Dict{UInt,UInt}, yD::Dict{UInt,UInt} = compressPoints(points)
        boolMat::Matrix{Bool}, boolMatPerimiter::Matrix{Bool} = createBooleanMat(compPoints)

        maxArea::UInt = 0
        currArea::UInt = 0
        for i::UInt in 1:size(points,1)
            for j in i+1:size(points,1)
                currArea = recArea(points[i,:],points[j,:])
                if currArea > maxArea
                    if isGreen(points[i,:],points[j,:],boolMat,xD,yD)
                        maxArea = currArea
                    end
                end
            end
        end

        return maxArea
    end
    run()
end