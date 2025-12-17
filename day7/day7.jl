global const DIR::String = "$(@__DIR__)/day7.txt"

function run()
    @time val = splitNum(DIR)
    shouldbe = 1499
    if val == shouldbe
        print("✓ Test Passed: $val == $shouldbe\n")
    else
        print("X Test Failed: $val != $shouldbe\n")
    end
    return nothing
end

function parseCharMAT(filepath::String)
    #Part two is a bruh moment
    allLines::Vector{String} = Vector{String}[]
    open(filepath) do file
        while !eof(file)
            push!(allLines,readline(file))
        end
    end

    strLen::UInt = length(allLines[1])
    charMat::Matrix{Char} = Matrix{Char}(undef,length(allLines),length(allLines[1]))
    for i in eachindex(allLines)
        if length(allLines[i]) != strLen
            @error "Line Length mismatch in parse"
        end
        charMat[i,:] = collect(allLines[i])
    end
    

    return charMat
end

function splitBeams(filepath::String)
    M = parseCharMAT(filepath)
    beamLine::Vector{Bool} = Vector{Bool}(undef,size(M,2)) 
    beamLine .= false
    splitNum::UInt = 0

    for i = 1:size(M,1)
        if i == 1
            for j = 1:size(M,2)
                if M[i,j] == 'S'
                    beamLine[j] = true
                end
            end
        else
            for j = 1:size(M,2)
                if M[i,j] == '^' && beamLine[j] == true
                    splitNum += 1
                    beamLine[j] = false
                    beamLine[j-1] = true
                    beamLine[j+1] = true
                end
            end
            for j = 1:size(M,2)
                if beamLine[j] == true
                    M[i,j] = '|'
                end
            end
        end

        
    end

    return M, splitNum
end

function splitNum(filepath::String)
    M,s = splitBeams(filepath)
    #=for row in eachrow(M)
        println(join(row))
    end=#
    println()
    return s
end

run()