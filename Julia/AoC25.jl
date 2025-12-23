global const inputDIR = "$(@__DIR__)/../Input"
global const inputExDIR = "$(@__DIR__)/../InputEx"
global const scriptDIR = "$(@__DIR__)/days"

function AoC25()
    for i = 1:10
        include("$scriptDIR/day$i.jl")
    end
end

AoC25()

function runAllDays()
    day1()
    day2() #could be faster?
    day3()
    day4()
    day5()
    day6()
    day7()
    day8() #Really Slooooow
    day9()
end
#work on factoring out tests separately from day scripts