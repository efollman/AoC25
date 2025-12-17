global const currDIR::String = @__DIR__

function run()
    @time val = solveProblems("$currDIR/day6.txt")
    shouldbe = 6957525317641
    if val == shouldbe
        print("✓ Test Passed: $val == $shouldbe\n")
    else
        print("X Test Failed: $val != $shouldbe\n")
    end
    return nothing
end

function parseProblems(filepath::String)
    numbers::Matrix{Int} = Matrix{Bool}(undef,0,0)
    operators::Vector{Char} = []
    open(filepath) do file
        let
            currLine::String = ""
            currLineSplit::Vector{String} = []
            currLineNums::Vector{Int} = []
            i::UInt = 1

            while !eof(file)
                currLine = readline(file)
                currLineSplit = split(currLine," ")
                filter!(!isempty,currLineSplit)
                
                if i == 1
                    numbers = Matrix{Int}(undef,1,length(currLineSplit))

                    for str in currLineSplit
                        push!(currLineNums,parse(Int,str))
                    end

                    numbers[i,:] = currLineNums

                elseif all(isdigit,currLineSplit[1])
                    (_,width) = size(numbers)

                    for str in currLineSplit
                        push!(currLineNums,parse(Int,str))
                    end


                    if length(currLineNums) != width
                        @error "Line width mismatch"
                    end

                    numbers = vcat(numbers,transpose(currLineNums))
                else
                    for str in currLineSplit
                        push!(operators,str[1])
                    end
                end

                i += 1
                currLineNums = []
            end
        end
    end
    return numbers, operators
end

function solveProblems(filepath::String)

    numbers::Matrix{Int}, operators::Vector{Char} = parseProblems(filepath)

    _,y = size(numbers)

    numVec::Vector{Int} = []
    lineAnswer::Int = 0
    totalAnswer::Int = 0

    for j = 1:y
        numVec = numbers[:,j]
        if operators[j] == '*'
            lineAnswer = prod(numVec)
        elseif operators[j] == '+'
            lineAnswer = sum(numVec)
        end
        totalAnswer += lineAnswer
    end

    return totalAnswer

end

run()