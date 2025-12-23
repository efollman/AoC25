#Part 1 complete!
#Part2 is yikes
#speed improvment likely possible with using bitwise operators instead of parsing a binary representation as a string in the pressing sim.

function day10()

    function run()
        println("Running day10:")
        @time val = day10main("$inputDIR/day10.txt")
        shouldbe = 486
        if val == shouldbe
            print("✓ Test Passed: $val == $shouldbe\n")
        else
            print("X Test Failed: $val != $shouldbe\n")
        end
        println()
        return nothing
    end

    function parseFile(filepath::String)
        currLine::Vector{String} = []
        machines::Dict{UInt,Dict{String,Union{Vector{Bool},Vector{Vector{UInt}},Vector{UInt}}}} = Dict()
        lineCount::UInt = 1
        buttonCount::UInt = 1

        open(filepath) do file
            while !eof(file)
                machines[lineCount] = Dict()
                currLine = split(readline(file)," ")
                for str in currLine
                    if str[1] == '['
                        machines[lineCount]["Indicator"] = extractIndicator(str)
                    elseif str[1] == '('
                        if buttonCount == 1
                            machines[lineCount]["Buttons"] = Vector{UInt}[]
                        end
                        push!(machines[lineCount]["Buttons"],extractNumList(str))
                        buttonCount += 1
                    elseif str[1] == '{'
                        machines[lineCount]["Joltage"] = extractNumList(str)
                    else
                        @error "Parse Logic Fault"
                    end
                end
                lineCount += 1
                buttonCount = 1
            end
        end
        return machines
    end

    function extractIndicator(str::String)
        boolVec::Vector{Bool} = []

        for char in str
            if char == '.'
                push!(boolVec,false)
            elseif char == '#'
                push!(boolVec,true)
            elseif char == '[' || char == ']'
            else
                @error "Indicator Parse Logic Fault"
            end
        end

        return boolVec
    end
    
    function extractNumList(str::String)
        numList::Vector{UInt} = []
        currN::String = ""

        for char in str
            if isnumeric(char)
                currN = currN * char
            elseif char == ',' || char == ')' || char == '}'
                push!(numList,parse(UInt,currN))
                currN = ""
            elseif char == '(' || char == '{'
            else
                @error "Indicator Parse Logic Fault"
            end
        end

        return numList
    end

    function day10main(filepath::String)
        machines::Dict{UInt,Dict{String,Union{Vector{Bool},Vector{Vector{UInt}},Vector{UInt}}}} = parseFile(filepath)

        minPress::UInt = 0
        for i in keys(machines)
            minPress += minPressMachine(machines[i])
        end

        return minPress

    end

    function minPressMachine(machine::Dict{String,Union{Vector{Bool},Vector{Vector{UInt}},Vector{UInt}}})
        indicator::Vector{Bool} = machine["Indicator"]
        buttons::Vector{Vector{UInt}} = machine["Buttons"]
        
        currInd::Vector{Bool} = fill(false,length(indicator))
        currComb::UInt = 0
        currCombS::String = ""
        currCombMax = 2^(length(buttons))-1
        presses::UInt = 0
        minPresses::UInt = typemax(UInt)

        while currComb <= currCombMax
            currCombS = bitstring(currComb)[end-(length(buttons))+1:end]
            for chari in eachindex(currCombS)
                if currCombS[chari] == '1'
                    currInd = pressButton(currInd,buttons[chari])
                    presses +=1
                elseif currCombS[chari] == '0'
                else
                    @error "button combination logic fault"
                end
            end
            if currInd == indicator && presses < minPresses
                minPresses = presses
            end
            currComb += 1
            presses = 0
            currInd = fill(false,length(currInd))
        end
        return minPresses   
    end

    function pressButton(ind::Vector{Bool},button::Vector{UInt})
        for i in button
            ind[i+1] = !ind[i+1] #input 0 indexed
        end
        return ind
    end

    run()
end