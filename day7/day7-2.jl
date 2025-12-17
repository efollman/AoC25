global const DIR::String = "$(@__DIR__)/day7.txt"

function run()
    @time val = splitNum(DIR)
    shouldbe = 24743903847942
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
    beamLine::Vector{UInt} = Vector{UInt}(undef,size(M,2)) 
    beamLine .= 0

    for i = 1:size(M,1)
        if i == 1
            for j = 1:size(M,2)
                if M[i,j] == 'S'
                    beamLine[j] = 1
                    break
                end
            end
        else
            for j = 2:size(M,2)-1
                if M[i,j] == '^' && beamLine[j] > 0
                    beamLine[j-1] += beamLine[j]
                    beamLine[j+1] += beamLine[j]
                    beamLine[j] = 0
                end
            end
            #=for j = 1:size(M,2)
                if beamLine[j] > 0
                    M[i,j] = '|'
                end
            end=#
        end
        
        
    end

    splitNum = sum(beamLine)

    return M, splitNum
end

function splitNum(filepath::String)
    _,s::UInt = splitBeams(filepath)
    #=for row in eachrow(M)
        println(join(row))
    end=#
    println()
    return s
end

run()