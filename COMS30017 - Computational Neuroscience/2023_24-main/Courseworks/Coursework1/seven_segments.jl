#for the submission uncomment the submission statements
#see submission README

#include("submission.jl")

function seven_segment(pattern::Array{Int64})

    function to_bool(a::Int64)
        if a==1
            return true
        end
        false
    end

    function hor(d)
        if d
            println(" _ ")
        else
            println("   ")
        end
    end
    function vert(d1,d2,d3)
        word=""::String
        if d1
            word="|"
        else
            word=" "
        end
        if d3
            word=string(word,"_")
        else
            word=string(word," ")
        end
        if d2
            word=string(word,"|")
        else
            word=string(word," ")
        end
        println(word)

    end

    pattern_b=map(to_bool,pattern)

    hor(pattern_b[1])
    vert(pattern_b[2],pattern_b[3],pattern_b[4])
    vert(pattern_b[5],pattern_b[6],pattern_b[7])

    number=0
    for i in 1:4
        if pattern_b[7+i]
            number+=2^(i-1)
        end
    end

    println(number)

end

#f=open("./your_name.tex","w")
#header(f,"Your Name")

six=Int64[1,1,-1,1,1,1,1,-1,1,1,-1]
three=Int64[1,-1,1,1,-1,1,1,1,1,-1,-1]
one=Int64[-1,-1,1,-1,-1,1,-1,1,-1,-1,-1]

seven_segment(three)
seven_segment(six)
seven_segment(one)


##this assumes you have called your weight matrix "weight_matrix"
#section(f,"Weight matrix")
#matrix_print(f,"W",weight_matrix)



#------------------

println("test1")
#section(f,"Test 1")

test=Int64[1,-1,1,1,-1,1,1,-1,-1,-1,-1]

seven_segment(test)
#seven_segment(f,test)
##for COMSM0027

##where energy is the energy of test
#qquad(f)
#print_number(f,energy)
##this prints a space
#qquad(f)

#here the network should run printing at each step
#for the final submission it should also output to submission on each step



println("test2")
#section(f,"Test 2")

test=Int64[1,1,1,1,1,1,1,-1,-1,-1,-1]

seven_segment(test)
#seven_segment(f,test)
##for COMSM0027

##where energy is the energy of test
#qquad(f)
#print_number(f,energy)
##this prints a space
#qquad(f)

#here the network should run printing at each step
#for the final submission it should also output to submission on each step

# bottomer(f) # close the tex file
