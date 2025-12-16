global const currDIR::String = @__DIR__

function run()
    @time val = accessablePaper("$currDIR/day4.txt")
    shouldbe = 9784
    if val == shouldbe
        print("✓ Test Passed: $val == $shouldbe\n")
    else
        print("X Test Failed: $val != $shouldbe\n")
    end
    return nothing
end

function parsePaperLayout(filepath::String)
    paperLayout::Matrix{Bool} = Matrix{Bool}(undef,0,0)
    open(filepath) do file
        let
            currLine::String = ""
            currLineBool::Vector{Bool} = []
            i::UInt = 1

            while !eof(file)
                currLineBool = Vector{Bool}[]
                currLine = readline(file)
                for char in currLine
                    if char == '.'
                        push!(currLineBool,false)
                    elseif char == '@'
                        push!(currLineBool,true)
                    else
                        @error "Unexpected Char"
                    end
                end

                if i == 1
                    paperLayout = Matrix{Bool}(undef,1,length(currLineBool))
                    paperLayout[i,:] = currLineBool
                else
                    (_,width) = size(paperLayout)
                    if length(currLineBool) != width
                        @error "Line width mismatch"
                    end
                    paperLayout = vcat(paperLayout,transpose(currLineBool))
                end
                i += 1


            end
        end
    end
    return paperLayout
end

function accessablePaper(filepath::String)
    layout = parsePaperLayout(filepath)
    (x::UInt,y::UInt) = size(layout)

    accessibleN::UInt = 0
    oldN::UInt = 0

    flag::Bool = false
    while flag == false

        for i = 1:x
            for j = 1:y
                if layout[i,j] == true
                    irange,jrange = findAdjacent(i,j,x,y)
                    if sum(layout[irange,jrange])-1 < 4
                        accessibleN += 1
                        layout[i,j] = false
                    end
                end
            end
        end

        if accessibleN == oldN
            flag = true
            break
        end

        oldN = accessibleN
    end

    return accessibleN
end

function findAdjacent(i,j,x,y)
    amin::Int = i-1
    amax::Int = i+1
    bmin::Int = j-1
    bmax::Int = j+1

    if i-1 < 1 amin = 1 end
    if i+1 > x amax = x end
    if j-1 < 1 bmin = 1 end
    if j+1 > x bmax = y end

    arange = amin:amax
    brange = bmin:bmax
    return arange,brange
end

run()