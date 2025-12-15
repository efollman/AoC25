global const currDIR::String = @__DIR__

function passfunc(filedir::String)
    open(filedir) do file

        counter = 0
        dial = 50

        while !eof(file)
            currLine = readline(file)
            value = parse(Int,currLine[2:end])
            sign = 0

            #Lol this bad fix fr fr
            if currLine[1] == 'L'
                sign = -1
            elseif currLine[1] == 'R'
                sign = 1
            else
                @error "Not L or R???"
            end

            for i = 1:value
                dial += 1*sign
                if dial == 0 || dial == 100
                    counter += 1
                end
                dial = mod(dial,100)
            end
            #println(counter)
            #if dial == 0
            #    counter += 1
            #end
        end
        return counter
    end
end

function run()
    test = passfunc("$currDIR/day1ex.txt")
    if test == 6
        println("Test ex passed: $test")
    end
    @time test = passfunc("$currDIR/day1.txt")
    if test == 6738
        println("Test real passed: $test")
    end
    return nothing
end

run()
