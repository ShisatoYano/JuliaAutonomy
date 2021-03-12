# calculate expected value

module CalcExpValue
    function main()
        samples = rand(1:6, 10000)

        exp_value = sum(samples) / length(samples)

        println("Random sampling 10000 times with 6 sided dice")
        println("Expected value = $(exp_value)")
    end
end

if abspath(PROGRAM_FILE) == @__FILE__
    using .CalcExpValue
    CalcExpValue.main()
end