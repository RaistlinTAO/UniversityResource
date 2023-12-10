# -*- coding: utf-8 -*-
"""
Created on Tue Sep  1 10:17:54 2020
Updated on Tue Sep 13 12:03:13 2022

@author: sb15704
"""

# This code is provided for the first GA lab class for the AI unit (COMSM0014)

# It implements a very simple GA solving the "methinks it is like a weasel" problem.

# The brief for this lab comes in two parts.
# Both are available from the unit's Blackboard page for Week 4.
#   Part 0 will be circulated ahead of the lab.
#   Part 1 will be circulated at the start of the lab.

# Before the lab, please get this code running and play with the simple_main() and batch_main() function calls.

# The lab will require you to run different variants of this code and record the performance that results.
# You will benefit from being able to plot the data in good graphs. Look into how you want to do this.
# You will also have to make some small changes to the code to implement new variants of the GA in order to answer some of the questions.

# So please have a look at the code before the lab and try to understand how it works.

# Feel free to ask questions and discuss with others on the unit!


import random       # from random, we use "seed", "choice", "sample", "randrange", "random"
import statistics   # from statistics we just use "mean", "stdev"


# Initialise the GA population
#   Fill an empty population array with N=pop_size random individuals
#   Each individual is represented by a Python dictionary with two elements: "solution" and "fitness"
#     each "fitness" is initialised to <None> as the associated solution has not yet been assessed
#     each "solution" is initialised to a string of random symbols from the alphabet
#     either each "solution" is the same random string (converged=True) or
#     each "solution" is a different random string (converged=False)
#     the function as provided doesn't implement the converged=True functionality
def initialise(pop_size, genome_length, genetic_alphabet, converged=False):

    pop = []

    while len(pop)<pop_size:
        solution = "".join([random.choice(genetic_alphabet) for _ in range(genome_length)])
        pop.append({"fitness":None, "solution":solution})

    return pop


# Count the number of locations for which two strings of the same length match.
#   E.g, matches of "red", "rod" should be 2.
def matches(str1, str2):
    return sum(str1[i]==str2[i] for i in range(len(str1)))


# Assess the fitness of each individual in the current population
#   For each individual, count the number of symbols in the solution that match the target string
#   Store this as the fitness of the individual (normalised by the target string length)
#   Maximum fitness is thus 1 (all symbols match); minimum fitness is 0 (no matches).
#   Sort the population by fitness with the best solution at the top of the list
#     * this last step is important because it helps us track the best solution and
#       will also be useful when we implement elitism...
def assess(pop, target):

    length = len(target)
    for i in pop:
        i["fitness"] = matches(i["solution"], target) / length

    return sorted(pop, key = lambda i: i["fitness"], reverse=True)    # <<< *important


# Run tournament selection to pick a parent solution
#   Consider a sample of tournament_size unique indivduals from the current population
#   Return the solution belonging to the winner (the individual with the highest fitness)
def tournament(pop, tournament_size):

    competitors = random.sample(pop, tournament_size)

    winner = competitors.pop()
    while competitors:
        i = competitors.pop()
        if i["fitness"] > winner["fitness"]:
            winner = i

    return winner["solution"]


# Breed a new generation of solutions from the existing population
#   Generate N offspring solutions from a population of N individuals
#   Choose parents with a bias towards those with higher fitness
#   We can do this in a few different ways: here we use tournament selection
#   We can opt to employ 'elitism' which means the current best individual
#   always gets copied into the next generation at least once
#   We can opt to use 'crossover' (uniform or single point) which combines
#   two parent genotypes into one offspring
#   (Elitism is not yet implemented in the current code)
def breed(pop, tournament_size, crossover, uniform, elitism):

    offspring_pop = []

    while len(offspring_pop)<len(pop):
        mum = tournament(pop, tournament_size)
        if random.random()<crossover:
            dad = tournament(pop, tournament_size)
            offspring_pop.append({"fitness":None, "solution":cross(mum, dad)})
        else:
            offspring_pop.append({"fitness":None, "solution":mum})

    return offspring_pop


# Apply mutation to the population of new offspring
#   Each symbol in each solution may be replaced by a randomly chosen symbol from the alphabet
#   For each symbol in each solution the chance of this happening is set by the mutation parameter
#   (Elitism is not yet implemented in the current code)
#   (Python doesn't let us change a character at location i within a string like this: string[i]=new
#   so we splice a new character into the string like this: string = beginning + new + end)
def mutate(pop, mutation, alphabet, elitism):

    length = len(pop[0]["solution"])
    for i in pop[0:]:
        for j in range(length):
            if random.random()<mutation:
                i["solution"] = i["solution"][:j] + random.choice(alphabet) + i["solution"][j+1:]

    return pop


# Crossover the solution string of two parents to make an offspring
#   (This code implements 'one-point crossover')
#   Pick a random point in the solution string,
#   Use the mum's string up to this point and the dad's string after it
def cross(mum, dad):
    point = random.randrange(len(mum))
    return mum[:point] + dad[point:]


# Write a line of summary stats for population pop at generation gen
#   if File is None we write to the standard out, otherwise we write to the File
#   (In addition to writing out the max, min, and mean fitness for the pop, we
#   could write out a measure of population "covergence", e.g., std dev of fitness
#   or the match() between the best solution and the median solution in the pop
#   but that's not implemented here yet.)
def write_fitness(pop, gen, file=None):

    fitness = [p["fitness"] for p in pop]

    line = "{:4d}: max:{:.3f}, min:{:.3f}, mean:{:.3f}".format(gen,max(fitness),min(fitness),statistics.mean(fitness))

    if file:
        file.write(line+"\n")
    else:
        print(line)


# The main function for the GA
#  The function takes a number of arguments specifying various parameters and options
#  each argument has a default value which can be overloaded in the function call..
#   Seed the pseudo-random number generator (using the system clock)
#     so no two runs will have the same sequence of pseudo-random numbers
#   Set the length of the solution strings to be the length of the target string
#   Set the mutation rate to be equivalent to "on average 1 mutation per offspring"
#   Initialise a population of individuals
#   Assess each member of the initial population using the fitness function
#   Run a maximum of max_gen generations of evolution
#     (stopping early if we find the perfect solution)
#   Each generation of evolution comprises:
#     increment the generation counter
#     breed a new population of offspring
#     mutate the new offspring
#     assess each member of the new population using the fitness function and sort pop by fitness
#     track the best (highest fitness) solution in the current population (the 0th item in the list)
#     if we are writing stats and we want to write stats this generation:
#       write out some stats
#   Return the final generation count and the best individual from the final population
def do_the_ga(pop_size=100, tournament_size=2, crossover=0.0, uniform=False,
              elitism=False, max_gen=1000, converged=False, write_every=1, file=None,
              target="methinks it is like a weasel",
              alphabet="abcdefghijklmnopqrstuvwxyz "):

    random.seed()

    length = len(target)
    mutation = 1.0/length # << this line in the original code sets the mutation relative to the genome length

    pop = initialise(pop_size, length, alphabet, converged)
    pop = assess(pop,target)

    generation = 0
    best = pop[0]
    while generation < max_gen and best["fitness"] < 1:
        generation += 1
        pop = breed(pop, tournament_size, crossover, uniform, elitism)
        pop = mutate(pop, mutation, alphabet, elitism)
        pop = assess(pop, target)
        best = pop[0]
        if write_every and generation % write_every==0:
            write_fitness(pop, generation, file)

    return generation, best 


####################################################################
# Info on the parameters that do_the_ga() takes, and their defaults:
####################################################################
#
# The following variables parameterise the GA, a default value and a brief description is given for each
#
#    target   = "methinks it is like a weasel" # this is the 28-character target solution that we are trying to evolve
#    alphabet = "abcdefghijklmnopqrstuvwxyz "  # this is the set of 27 symbols from which we can build potential solutions
#
#    pop_size = 100                            # the number of individuals in one generation
#    tournament_size = 2                       # the size of the breeding tournament
#    mutation = 1.0/length                     # the chance that each symbol will be mutated; default: on average 1 mutation per offspring
#
#    crossover = 0.0                           # the chance that an offspring is the result of sexual crossover; default: zero chance 
#    uniform  = False                          # use uniform crossover? default: no, use single-point crossover
#    elitism  = False                          # is elitism turned on or off? default: no elitism
#    converged = False                         # is the initial population converged? default: not converged
#
#    max_gen  = 1000                           # the maximum number of evolutionary generations that will be simulated
#
#    write_every = 1                           # write out some summary stats every x generations - can be useful to set this to 10 or 100 to speed things up, or set it to zero to never write stats
#    file  = None                              # write the stats out to a file, or to std out if no file is supplied
#
####################################################################


# Examples of how to call the GA...
def simple_main():

    # call the GA with the default set up, receive the final generation count and the final best individual
    gens, best = do_the_ga()
    print("{:4d} generations yielded: '{}' ({:.3f})".format(gens,best["solution"],best["fitness"]))
    input("hit return to continue")

    # call the GA with the default set up (but write stats to a file), receive the final generation count and the final best individual
    # (be careful about over-writing your output file if you run this again!)
    with open("ga_output.dat",'w') as f:
        gens, best = do_the_ga(file=f)
        print("{:4d} generations yielded: '{}' ({:.3f})".format(gens,best["solution"],best["fitness"]))
    input("hit return to continue")

    # call the GA with a longer target string than the default set up, don't bother writing out any stats during evolution
    gens, best = do_the_ga(target="something quite a bit longer than methinks it is like a weasel", write_every=0)
    print("{:4d} generations yielded: '{}' ({:.3f})".format(gens,best["solution"],best["fitness"]))
    input("hit return to continue")


# Example of how we might explore the impact of varying a parameter on the performance of our GA
def batch_main():

    # open a file to store the results in...
    with open("ga_output_max_gen_100_to_6400.dat",'w') as f:
        # loop over different parameter values for population size to see what difference it makes..
        for max_gen in [100, 200, 400, 800, 1600, 3200]:
            # call the GA - tell it to only write out stats for the final generation of evolution..
            gens, best = do_the_ga(max_gen=max_gen, file=f, write_every=max_gen)
            print("With max_gen={:4d}, {:4d} generations yielded: '{}' ({:.3f})".format(max_gen, gens, best["solution"], best["fitness"]))

# Calling two examples main functions

simple_main()
batch_main()



# Complete the lab by writing code for each of these empty functions:

# q1 just requires calling the do_the_ga() function with the standard parameters
# def q1():
    #   code here

# q2a requires calling the do_the_ga() function repeatedly with different values for the tournament size...
# def q2a():

# def q2b():
#   code here

# def q2c():
#   code here

# def q2d():
#   code here

# def q2e():
#   code here

# def q3a():
#   code here

# def q3b():
#   code here

# def q3c():
#   code here

# def q4():
#   code here


# Function calls for new functions to be written for each of the Lab Sheet Questions
# q1()
# q2a()
# q2b()
# q2c()
# q2d()
# q2e()
# q3a()
# q3b()
# q3c()
# q4()





# I've also provided a separate python file with a "t-test" function in it in case anyone
# wants to use a t-test to check whether the behaviour of two GAs is significantly different
# This isn't required - but if you were doing a proper analysis of GA performance you'd want
# to think about stats of some kind...

from t_test import t_test as t_test

# check the t-test.py file for more info on how to call the t_test function
