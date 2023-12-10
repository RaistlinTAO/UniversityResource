# -*- coding: utf-8 -*-
"""
Created on Tue Sep  1 10:17:54 2020
Updated on Mon Oct 16 17:18:13 2023

@author: sb15704
"""

# This code is provided for the first GA lab class for the AI unit (COMSM0012/13/14)

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

    # vv code for implementing a converged initial population required for q3b vv
    if converged:
        solution = "".join(random.choice(genetic_alphabet) for _ in range(genome_length))
        while len(pop)<pop_size:
            pop.append({"fitness":None, "solution":solution})
    else:
    # vv default code provided for implementing a random initial population vv
        while len(pop)<pop_size:
            solution = "".join(random.choice(genetic_alphabet) for _ in range(genome_length))
            pop.append({"fitness":None, "solution":solution})

    return pop


# Count the number of locations for which two strings of the same length match.
#   E.g, matches of "red", "rod" should be 2.
def matches(str1, str2):
    return sum([str1[i]==str2[i] for i in range(len(str1))])


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
#   Consider a sample of tournament_size unique individuals from the current population
#   Return the solution belonging to the winner (the individual with the highest fitness)
def tournament(pop, tournament_size):

    competitors = random.sample(pop, tournament_size)

    winner = competitors.pop()
    while competitors:
        i=competitors.pop()
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
#   (Elitism is not implemented in the original code)
def breed(pop, tournament_size, crossover, uniform, elitism):

    offspring_pop = []

    # vv code for Elitism required for q3a vv #
    if elitism:
        elite = pop[0]
        offspring_pop.append({"fitness":None, "solution":elite["solution"]})
    # ^^ code for Elitism required for q3a ^^ #

    while len(offspring_pop)<len(pop):
        mum = tournament(pop, tournament_size)
        if random.random()<crossover:                                           # << crossover code for q3c
            dad = tournament(pop, tournament_size)                              # << crossover code for q3c
            offspring_pop.append({"fitness":None, "solution":cross(mum, dad)})  # << crossover code for q3c
        else:
            offspring_pop.append({"fitness":None, "solution":mum})              # << original code for asexual reproduction

    return offspring_pop


# Apply mutation to the population of new offspring
#   Each symbol in each solution may be replaced by a randomly chosen symbol from the alphabet
#   For each symbol in each solution the chance of this happening is set by the mutation parameter
#   (Elitism is not yet implemented in the current code)
#   (Python doesn't let us change a character at location i within a string like this: string[i]="a"
#   so we splice a new character into the string like this: string = beginning + new + end)
def mutate(pop, mutation, alphabet, elitism):

    # if elitism is False we want to loop over all members of the population and apply mutation to them
    # if elitism is True we want to skip the first member of the population and apply mutation to the rest
    length = len(pop[0]["solution"])
    for i in pop[elitism:]:                # << pop[elitism:] means we don't mutate the elite; original code supplied to students doesn't have this
        for j in range(length):
            if random.random()<mutation:
                i["solution"] = i["solution"][:j] + random.choice(alphabet) + i["solution"][j+1:]

    return pop


# Crossover the solution string of two parents to make an offspring
#   (This code implements 'one-point crossover')
#   Pick a random point in the solution string,
#   use the mum's string up to this point and the dad's string after it
def cross(mum, dad):
    point = random.randrange(len(mum))
    return mum[:point] + dad[point:]


# vv This code is for q3c uniform crossover option vv
# Uniform crossover of two parent solution strings to make an offspring
#   pick each offspring solution symbol from the mum or the dad with equal probability
def uniform_cross(mum, dad):
    return "".join( mum[i] if random.choice([True, False]) else dad[i] for i in range(len(mum)) )


# vv This code is just for fun, for q3c multi-point crossover option vv
# vv Not included in the code supplied to students                   vv
# Multi-point crossover of two parent solution strings to make an offspring
#   Pick n random points in the solution string,
#   use the mum's string up to the first point and the dad's string up to the second point, etc.
def multi_point_cross(mum, dad, n):
    genomes = [mum,dad]
    crosses = random.sample(range(len(mum)),n)
    parent = i = 0
    offspring = ""
    while i<len(mum):
        offspring+=genomes[parent][i]
        if i in crosses:
            parent = 1-parent
        i+=1

    return offspring


# Write a line of summary stats for population pop at generation gen
#   if File is None we write to the standard out, otherwise we write to the File
#   (In addition to writing out the max, min, and mean fitness for the pop, we
#   now write out a measure of population "convergence", i.e., std dev of fitness,
#   and the match() between the best solution and the median solution in the pop
#   but that's not implemented here yet.)
def write_fitness(pop, gen, file=None):

    fitness = [p["fitness"] for p in pop]

    # calc how different the best current solution is from the current worst and the current median
    # because the population is sorted by fitness, the current 'best' is item [0] in the population,
    # the current worst is the last item [-1], and the 'median' individual is half-way down the list
    max_diff = len(pop[0]["solution"]) - matches(pop[0]["solution"],pop[-1]["solution"])
    med_diff = len(pop[0]["solution"]) - matches(pop[0]["solution"],pop[int(len(pop)/2)]["solution"])

    line = "{:4d}: max:{:.3f}, min:{:.3f}, mean:{:.3f}, stdev:{:.3f}, max_diff:{:2d}, med_diff:{:2d}".format(gen,max(fitness),min(fitness),statistics.mean(fitness),statistics.stdev(fitness),max_diff,med_diff)

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
              target="methinks it is like a weasel", m=1.0, # we added a new "m" parameter here to handle q2e
              alphabet="abcdefghijklmnopqrstuvwxyz "):

    random.seed()

    length = len(target)
    # mutation = 1.0/length # << this line in the original code sets the mutation relative to the genome length
    mutation =   m/length   # << we've added this new line to handle q2e

    pop = initialise(pop_size, length, alphabet, converged)
    pop = assess(pop, target)

    generation = 0
    best = pop[0]
    while generation < max_gen and best["fitness"] < 1:
        generation += 1
        pop = breed(pop, tournament_size, crossover, uniform,elitism)
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


# Examples of answers to each of the questions:


# q1 just requires calling the do_the_ga() function with the standard parameters
def q1():
    gens, best = do_the_ga()
    print("{:4d} generations yielded: '{}' ({:.3f})".format(gens,best["solution"],best["fitness"]))


# ts (tournament size) makes a big difference - big ts improves search
#   when ts is very large we are not really implementing evolution - more like hill climbing
#   when ts is 1 we are just doing random search
def q2a():
    for ts in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 20, 40, 80, 100]:
        gens, best = do_the_ga(tournament_size=ts,write_every=0)
        print("With tournament_size={:4d}, {:2d} generations yielded: '{}' ({:.3f})".format(ts, gens, best["solution"], best["fitness"]))


# target length doesn't seem to make much difference if the rest of the parameters are standard
#   we are seeing a "floor effect" - evolution finds all of the targets hard to discover
#   if we set tournament size to 3 then we start to see target length make a difference
#   with higher target length taking longer to solve
def q2b():
    for target in ["methinks", "methinks it is like", "methinks it is like a weasel", "methinks it is like a weasel but longer", "methinks it is like a weasel but much much longer indeed"]:
        gens, best = do_the_ga(target=target,tournament_size=3,write_every=0)
        print("With target={}, {:2d} generations yielded: '{}' ({:.3f})".format(target, gens, best["solution"], best["fitness"]))


# alphabet size might also seem to not make much difference if the selection pressure is too weak (ts=2)
#   again this is a "floor effect" - if ts=3 or ts=4 we see a clearer picture
#   if we set tournament size to 4 then we start to see alphabet size slow evolution down
#   does speed decrease linearly with increasing alphabet?
def q2c():
    for alphabet in ["abcdefghijklmnopqrstuvwxyz ", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ ", "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!£$%^&*()'[]{}@:~#;<>,./?|\`¬ "]:
        gens, best = do_the_ga(alphabet=alphabet,tournament_size=4,write_every=0)
        print("With alphabet={:2d}, {:2d} generations yielded: '{}' ({:.3f})".format(len(alphabet), gens, best["solution"], best["fitness"]))


# pop size has a straightforward positive effect on performance - but shows up differently for tournament size=2 or 3 or 4
def q2d():
    for pop_size in [10, 20, 40, 80, 160, 320, 640, 1280]:
        gens, best = do_the_ga(pop_size=pop_size,tournament_size=3,write_every=0)
        print("With pop_size={:3d}, {:2d} generations yielded: '{}' ({:.3f})".format(pop_size, gens, best["solution"], best["fitness"]))


# we need to make a change to the do_the_ga function
#   an easy one is to change the `m=1/length` command to `mutation = m/length` where m is a parameter that we pass to the function
#   very low mutation rates can reach the solution but take longer
#   high mutation rates fail to settle on the solution
#   varying mutation rate changes mutation selection balance by reducing/increasing mutation pressure
#   mutation = 0 allows no search
#   mutation = 1 allows no inheritance, effectively randomly sampling the space
def q2e():
    for m in [0.05, 0.1, 0.25, 0.33, 0.5, 1.0, 2.0, 3.0, 4.0, 5.0, 28.0]:
        gens, best = do_the_ga(m=m, write_every=0)
        print("With m={:.2f}, {:2d} generations yielded: '{}' ({:.3f})".format(m, gens, best["solution"], best["fitness"]))


# Elitism improves the performance of the GA.
def q3a():
    for run in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]:
        elitism=True
        gens, best = do_the_ga(elitism=elitism,write_every=0)
        print("With Elitism={}, {:2d} generations yielded: '{}' ({:.3f})".format(elitism, gens, best["solution"], best["fitness"]))
    for run in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]:
        elitism=False
        gens, best = do_the_ga(elitism=elitism,write_every=0)
        print("With Elitism={}, {:2d} generations yielded: '{}' ({:.3f})".format(elitism, gens, best["solution"], best["fitness"]))


# Converged or random initial population doesn't make any difference?
# This is because any initial diversity in the population collapses
# quickly, wiping out the difference between the two scenarios.
# This can be shown by plotting a measure of convergence over time.
def q3b():
    for run in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]:
        converged=True
        gens, best = do_the_ga(converged=converged,tournament_size=3,write_every=0)
        print("With Converged={}, {:2d} generations yielded: '{}' ({:.3f})".format(converged, gens, best["solution"], best["fitness"]))
        converged=False
        gens, best = do_the_ga(converged=converged,tournament_size=3,write_every=0)
        print("With Converged={}, {:2d} generations yielded: '{}' ({:.3f})".format(converged, gens, best["solution"], best["fitness"]))


# Crossover straightforwardly improves performance
# Is uniform crossover a bit better than 1-point crossover? Might need several runs and a t-test?
def q3c():
    for crossover in [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]:
        gens, best = do_the_ga(crossover=crossover,write_every=0)
        print("With 1-point crossover={:.2f}, {:2d} generations yielded: '{}' ({:.3f})".format(crossover, gens, best["solution"], best["fitness"]))
        gens, best = do_the_ga(crossover=crossover,uniform=True,write_every=0)
        print("With uniform crossover={:.2f}, {:2d} generations yielded: '{}' ({:.3f})".format(crossover, gens, best["solution"], best["fitness"]))


# This is a bit more involved - maybe only something that a student who has rocketed through the other questions will have time for
#  Here I show how I would look at how convergence changes over time for four different values of mutation probability
#  In each case I want to compare how fitness changes over evolutionary time with how solution diversity changes over time
#  I could measure "diversity" in many ways but an easy one is how different is the current best solution from the current median solution (using the matches() function)
#  The resulting graphs should show that:
#    very low mutation rate (0.05/L) means rapid loss of diversity in the population (="prematurely convergence") resulting in very slow progress
#    very high mutation rate (5/L) means very high diversity in the population because high mutation prevents heritability of good genes and hamstrings selection
#    intermediate mutation rate (0.05/L or 1/L) allows moderate diversity that is lost as the population gets closer to the optimal solution
def q4():
    # open a file to store the results in...
    with open("ga_output_mut_convergence_data.dat",'w') as f:
        # loop over different parameter values for mutation rate to see what difference it makes..
        for m in [0.05, 0.5, 1.0, 5.0]:
            gens, best = do_the_ga(m=m, write_every=1, file=f, max_gen=500) # call the GA with the right parameters
            print("With m={:.2f}, {:2d} generations yielded: '{}' ({:.3f})".format(m, gens, best["solution"], best["fitness"]))

# Function calls for new functions to be written for each of the Lab Sheet Questions
input("\nRun q1...\n[Hit return to continue]")
q1()

input("\nRun q2a...\n[Hit return to continue]")
q2a()

input("\nRun q2b...\n[Hit return to continue]")
q2b()

input("\nRun q2c...\n[Hit return to continue]")
q2c()

input("\nRun q2d...\n[Hit return to continue]")
q2d()

input("\nRun q2e...\n[Hit return to continue]")
q2e()

input("\nRun q3a...\n[Hit return to continue]")
q3a()

input("\nRun q3b...\n[Hit return to continue]")
q3b()

input("\nRun q3c...\n[Hit return to continue]")
q3c()

input("\nRun q4...\n[Hit return to continue]")
q4()

print("done")