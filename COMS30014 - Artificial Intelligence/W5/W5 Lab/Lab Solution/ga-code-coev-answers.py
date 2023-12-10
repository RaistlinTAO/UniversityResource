# -*- coding: utf-8 -*-
"""
Created on Tue Sep  1 10:17:54 2020
Updated on Tue Sep 13 15:00:23 2022

@author: sb15704
"""

import random       # we use "seed", "choice", "sample", "randrange", "random", "shuffle"
import statistics   # from statistics we just use "mean", "stdev"

# Initialise a GA Population
#   Fill an empty population array with N=pop_size new individuals
#   Each individual is represented by a dictionary with two elements: "fitness" and "solution"
#     each "fitness" is initialised to 0 as the associated solution has not yet been assessed
#     if zeropop is True (which is appropriate if we are replicating Cartlidge & Bullock, 2004)
#       each "solution" is initialised to a string of "0"s from the (binary) alphabet
#     otherwise, if zeropop is False (which is appropriate if we are just running regular evolution):
#       each "solution" gene is initialised to a different random symbol drawn from the (binary) alphabet
def initialise(pop_size, length, alphabet, zeropop=True):

    pop = []

    while len(pop)<pop_size:
        if zeropop:
            pop.append({"fitness":0, "solution":"0"*length})
        else:
            pop.append({"fitness":0, "solution":"".join([random.choice(list(alphabet)) for _ in range(length)])})

    return pop


# Apply Virulence Function
#    As per the Cartlidge and Bullock (2004) paper, we can impose a virulence function
#    on parasite fitness, either rewarding or punishing parasites that tend to win more
#    or less games vs. their host opponents.
#    First we normalise all parasite scores by dividing by the current maximum score
#    Then we map each parasite's normalised score (x) through the virulence function
#    which takes a parameter "para_lambda" that can range between 1.0 (maximum virulence)
#    and 0.5 (minimum virulence):
#      fitness = (2*x/par_lambda) - (x^2)/(para_lambda^2)
#    (Note, if all the original fitness values in the parasite population are zero,
#    then we just return them unchanged to avoid a division by zero problem during
#    normalisation.)
def apply_virulence(para_pop, para_lambda):

    max_para_fitness = 0
    for i in range(len(para_pop)):
        if para_pop[i]["fitness"] > max_para_fitness:
            max_para_fitness = para_pop[i]["fitness"]

    if max_para_fitness==0:
        return para_pop

    for i in range(len(para_pop)):
        normalised_score = para_pop[i]["fitness"]/max_para_fitness
        para_pop[i]["fitness"] = (2 * normalised_score / para_lambda) - ( (normalised_score**2)/(para_lambda**2) )

    return para_pop


# Assess the Fitness of Each Individual in the Current Population
#   We assess each individual host against n=num_competitions randomly chosen parasites.
#   i.e., for each of the n rounds of competitions we pair each host with a different random parasite
#   In each competition, we check whether the host or the parasite have more '1's in their solution.
#   Ties are broken in favour of the host. The competition winner gets a point of fitness.
#   Then we normalise each fitness score by dividing by the number of competitions.
#   So each parasite and host have a score between 0 (no wins) and 1 (no losses)
#   If the para_lambda parameter is between 0.5 and 1.0 we apply the virulence
#     function to the parasite fitness scores
#   Finally, we sort each population by fitness with the best solution at the top of the list
def assess(host_pop, para_pop, num_competitions, para_lambda):

    for competition in range(num_competitions):
        order = list(range(len(para_pop)))
        random.shuffle(order)

        for i in range(len(host_pop)):

            host = host_pop[i]
            para = para_pop[order[i]]

            if host["solution"].count("1") >= para["solution"].count("1"):
                host["fitness"]+=1
            else:
                para["fitness"]+=1

    for i in range(len(host_pop)):
        host_pop[i]["fitness"]/=num_competitions
        para_pop[i]["fitness"]/=num_competitions

    if para_lambda and 0.5 <= para_lambda <= 1.0 :
        para_pop = apply_virulence(para_pop, para_lambda)

    return sorted(host_pop, key = lambda i: i["fitness"], reverse=True), sorted(para_pop, key = lambda i: i["fitness"], reverse=True)


# Run Tournament Selection to Pick a Parent (same as code in GA Lab #1)
#   Consider a sample of tournament_size unique individuals
#   Return the solution belonging to the winner (the individual with the highest fitness)
def tournament(pop, tournament_size):

    competitors = random.sample(pop, tournament_size)

    winner = competitors.pop()
    while competitors:
        i = competitors.pop()
        if i["fitness"] > winner["fitness"]:
            winner = i

    return winner["solution"]


# Breed a New Generation of Solutions from the Existing Population
#   Generate N offspring solutions from a population of N individuals
#   Choose each mum with a bias towards those individuals with higher fitness
#   We can do this in a few different ways: here we use tournament selection
#   We don't use elitism and reproduction is asexual - to keep things simple
def breed(pop, tournament_size):

    offspring_pop = []

    while len(offspring_pop)<len(pop):
        mum = tournament(pop, tournament_size)
        offspring_pop.append({"fitness":0, "solution":mum})

    return offspring_pop


# Apply Mutation to the Population of New Offspring
# (Using a 'mutation bias' if one is given)
#   For each symbol in each solution the chance that it is replaced by a new random
#     symbol is set by the mutation_rate parameter.
#   When a symbol is set to be mutated, whether or not there is a *bias* on which
#     new symbol is picked from the alphabet is determined by the bias parameter
#     which is a list the same length as the alphabet.
#   An alphabet of "01" and bias=["0.5", "0.5"] means pick "0" and "1" with equal chance.
#   An alphabet of "01" and bias=["0.2", "0.8"] means pick "1" four times as often as "0".
#   An alphabet of "01" and bias=["0.0", "1.0"] means always pick "1".
#   The default is to implement an equal chance of choosing each symbol in the alphabet.
def mutate(pop, length, mutation_rate, alphabet, bias=None):

    if bias==None:
        bias = [1.0/len(alphabet)]*len(alphabet)

    for i in pop:
        for j in range(length):
            if random.random()<mutation_rate:
                i["solution"] = i["solution"][:j] + random.choices(alphabet,bias)[0] + i["solution"][j+1:]

    return pop


# Write Out a Line of Summary Stats for the Host and Parasite Populations
#   if file is None, we write to the standard out, otherwise we write to the file
#   (In addition to writing out the best solution, its relative fitness and
#   absolute fitness, we could write out population statistics for the hosts and
#   for the parasites, and we could also output a measure of population "covergence",
#   e.g., std dev of fitness scores, or the match() between the best solution and
#   the median solution in the pop but that's not implemented here yet.)
def write_fitness(hosts, paras, gen, file=None):

    best_host = hosts[0]
    best_para = paras[0]
    best_host["objective"] = best_host["solution"].count("1")
    best_para["objective"] = best_para["solution"].count("1")
    line1 = "{:4d} host: '{}' ({:.3f}) = {:3d}".format(gen, best_host["solution"], best_host["fitness"], best_host["objective"])
    line2 = "{:4d} para: '{}' ({:.3f}) = {:3d}".format(gen, best_para["solution"], best_para["fitness"], best_para["objective"])

    # host_fitness = [ h["fitness"] for h in hosts ]
    # para_fitness = [ p["fitness"] for p in paras ]
    # line1 += ", max:{:.3f}, min:{:.3f}, mean:{:.3f}".format(max(host_fitness), min(host_fitness), statistics.mean(host_fitness))
    # line2 += ", max:{:.3f}, min:{:.3f}, mean:{:.3f}".format(max(para_fitness), min(host_fitness), statistics.mean(para_fitness))

    if file:
        file.write(line1+"\n")
        file.write(line2+"\n")
    else:
        print(line1)
        print(line2)


# The Main Function for the Coevolutionary GA
#  The function takes a number of arguments specifying various parameters and options
#   - each argument has a default value
#    We seed the pseudo-random number generator (using the system clock)
#     - so that no two runs will have the same sequence of pseudo-random numbers
#    We initialise a population of individual "hosts"
#     - these are the solution "designs" that we are interested in
#    We initialise a population of individual "parasites"
#     - these are the solution "challenges" against which our hosts will coevolve
#    We assess each member of the two initial populations by calling assess()
#    We run max_gen generations of (co-)evolution:
#     Each generation comprises the following steps:
#      increment the generation counter
#      breed a new population of offspring hosts
#      if we are implementing coevolution: breed a new population of offspring parasites
#      otherwise: generate a new population of random parasites
#      mutate the new offspring hosts and mutate the new offspring parasites
#      assess each member of the two new populations
#      if we are writing stats and we want to write stats *this generation*:
#        write out some stats
#    We return the final generation count and the best (0th) host and parasite from the final populations
def do_the_ga(pop_size=50, length=100, tournament_size=5, max_gen=600, mutation_rate=0.03, para_lambda=1.0,
              num_competitions=10, alphabet="01", host_bias=[0.5,0.5], para_bias=[0.25,0.75], coevolution=True,
              write_every=10, file=None):

    random.seed()

    host_pop = initialise(pop_size, length, alphabet, zeropop = coevolution) # zeropop is a flag determining whether we initialise with 000.. bit strings or not
    para_pop = initialise(pop_size, length, alphabet, zeropop = coevolution) # zeropop is a flag determining whether we initialise with 000.. bit strings or not

    host_pop, para_pop = assess(host_pop, para_pop, num_competitions, para_lambda)

    generation = 0
    while generation < max_gen:
        generation += 1

        host_pop = breed(host_pop, tournament_size)
        if coevolution:
            para_pop = breed(para_pop, tournament_size)
        else:
            para_pop = initialise(pop_size, length, alphabet, zeropop = coevolution) # if we aren't doing coevolution just make a random bunch of parasites instead

        host_pop = mutate(host_pop, length, mutation_rate, alphabet, host_bias)
        para_pop = mutate(para_pop, length, mutation_rate, alphabet, para_bias)

        host_pop, para_pop = assess(host_pop, para_pop, num_competitions, para_lambda)

        if write_every and generation % write_every==0:
            write_fitness(host_pop, para_pop, generation, file)

    best_host = host_pop[0]
    best_para = para_pop[0]
    best_host["objective"] = best_host["solution"].count("1")
    best_para["objective"] = best_para["solution"].count("1")

    return generation, best_host, best_para




# Lab Answers:
#
# -- 1
#
# a) Search Space Dimensionality
#    the dimensionality of the space is the same as the length of the bitstring, L
# b) Search Space Epistasis
#    none - the contribution of each bit is independent of the others
# c) Number of Search Space Optima
#    one global optimum - no local optima - this is always the case with zero epistasis
# d) Basins of Attraction
#    one basic on attraction because there is one optimum
# e) Deception
#    no deception because only one basis of attraction
# f) Neutrality and Neutral Networks
#    no neutrality in one-bit neighbourhood of each solution
#    there is neutrality between a solution and some of its 2-bit neighbours
#    as two bit-flips could introduce a '1' and remove a '1' at the same time leaving fitness unchanged.
#
# -- 2
#
# a) if there is no mutation bias supplied to the mutation function, then we want to have an equal chance of each
#     alphabet symbol being chosen when a gene is mutated, so if there are A symbols in the alphabet we want to set
#     bias to be a list of A values with each value = 1/A
# b) if we need to mutate location j in a solution, we need to add three parts together to make the mutated solution:
#    part 1 is the original bits before location j
#    part 2 is a random bit selected from the alphabet using the specified bias probabilities
#    part 3 is all the original bits after location j
# c) for each round of competition we want to randomly pair each host with a different parasite
#    so we start by setting order to be the list [0 ... N-1]
#    then we shuffle this list so that element i in the list points to a unique random number between 0 and N-1
# d) we pit host number i against parasite number order[i] where order[i] is now a unique random number between 0 and N-1
#    (a more naive approach would be to i) repeatedly pick a random host and random parasite and make them fight
#    or to ii) loop through the hosts and make each host fight a randomly selected parasite
#    - what's the problem with this? some parasites will play more games than others, which will bias
#    our evalution of parasites and introduce additional noise into evolution...)
# e) if the best fitness in the para population is zero then all parasites have fitness zero and we don't need to
#    map them through the parasite virulence function as they will still all be the same value, so leave them alone
#    this avoids a division by zero error
# f) this line implements the parasite virulence function from Cartlidge and Bullock (2004).
#    a parasite with normalised fitness, x, is given a new fitness value = 2x/lambda - (x^2/lambda^2)
#    zero fitness always maps to zero, irrespective of the value of lambda or of the other fitness values in the population
#    if lambda = 1, fitness is maximum for x = 1 and fitness ranks are therefore left unchanged
#    if lambda = 0.75, fitness is maximum for x = 0.75 and lowest for x=0, the fitness for x=1 is 0.8889
#    if lambda = 0.5, fitness is maximum for x = 0.5 and lowest for x=1 and x=0

# -- 3

def q3():

    print("3a")
    gens, best_host, best_para = do_the_ga(coevolution=False)
    print("\nDone: Evolution")
    print("{:4d} host: '{}' ({:.3f}) = {:3d}".format(gens,best_host["solution"],best_host["fitness"], best_host["objective"]))
    print("{:4d} para: '{}' ({:.3f}) = {:3d}".format(gens,best_para["solution"],best_para["fitness"], best_para["objective"]))
    print("")
    print("Evolution is not under any pressure to improve the host solution once hosts are somewhat better than random bitstrings.\n")
    input("")

    print("3b")
    gens, best_host, best_para = do_the_ga(coevolution=True)
    print("\nDone: Coevolution")
    print("{:4d} host: '{}' ({:.3f}) = {:3d}".format(gens,best_host["solution"],best_host["fitness"], best_host["objective"]))
    print("{:4d} para: '{}' ({:.3f}) = {:3d}".format(gens,best_para["solution"],best_para["fitness"], best_para["objective"]))
    print("")
    print("Coevolution took around 200 generations to find a perfect host.\n")
    input("")

    print("3c")
    gens, best_host, best_para = do_the_ga(para_lambda=1, para_bias= [0.1,0.9])
    print("\nDone: Lamda=1.0 - Maximum Virulence; Strong parasite mutation bias [0.1, 0.9]")
    print("{:4d} host: '{}' ({:.3f}) = {:3d}".format(gens,best_host["solution"],best_host["fitness"], best_host["objective"]))
    print("{:4d} para: '{}' ({:.3f}) = {:3d}".format(gens,best_para["solution"],best_para["fitness"], best_para["objective"]))
    print("")
    print("With strong bias in favour of the parasites, hosts get left behind and the populations disengage.\n")
    print("Parasites drift to 90% 1s (their mutation bias), and hosts drift to their average genotype = ~50% 1s\n")
    input("")

    print("3d")
    gens, best_host, best_para = do_the_ga(para_lambda=0.75, para_bias= [0.1,0.9])
    print("\nDone: Lamda=0.75 - Moderate Virulence; Strong parasite mutation bias [0.1, 0.9]")
    print("{:4d} host: '{}' ({:.3f}) = {:3d}".format(gens,best_host["solution"],best_host["fitness"], best_host["objective"]))
    print("{:4d} para: '{}' ({:.3f}) = {:3d}".format(gens,best_para["solution"],best_para["fitness"], best_para["objective"]))
    print("")
    print("Despite the strong bias in favour of the parasites, hosts no longer get left behind because of moderate virulence.\n")
    print("Parasites climb to around 97% 1s and so do hosts.\n")
    print("Why don't hosts and paras reach 100% 1s? Moderate virulence prevents parasites from really applying the final push.\n")
    input("")

    print("3e")
    gens, best_host, best_para = do_the_ga(para_lambda=1.0, para_bias= [0.4,0.6])
    print("\nDone: Lamda=1.0 - Maximum Virulence; Weak parasite mutation bias [0.4, 0.6]")
    print("{:4d} host: '{}' ({:.3f}) = {:3d}".format(gens,best_host["solution"],best_host["fitness"], best_host["objective"]))
    print("{:4d} para: '{}' ({:.3f}) = {:3d}".format(gens,best_para["solution"],best_para["fitness"], best_para["objective"]))
    print("")
    print("Now with weaker bias in favour of the parasites, hosts no longer get left behind even with maximum virulence parasites.\n")
    print("Hosts are able to keep pace with parasites, and both climb to around 98% or 99% 1s.\n")
    print("Hosts and paras get closer to 100% 1s. Maximum virulence parasites are happy to punish hosts for missing even 1 or 2 '1's.\n")
    print("What if we reduced host mutation rate might that slow them down and allow disengagement to occur?\n")
    input("")

    print("3f")
    gens, best_host, best_para = do_the_ga(para_lambda=0.75, para_bias= [0.4,0.6])
    print("\nDone: Lamda=0.75 - Moderate Virulence; Weak parasite mutation bias [0.4, 0.6]")
    print("{:4d} host: '{}' ({:.3f}) = {:3d}".format(gens,best_host["solution"],best_host["fitness"], best_host["objective"]))
    print("{:4d} para: '{}' ({:.3f}) = {:3d}".format(gens,best_para["solution"],best_para["fitness"], best_para["objective"]))
    print("")
    print("Staying with weaker bias in favour of the parasites, but employing moderate virulence parasites...\n")
    print("Hosts are able to keep pace with parasites, and both climb to around 93% or 95% 1s.\n")
    print("No problems with disengagement, but moderate virulence parasites are not interested in punishing hosts for missing the last few '1's.\n")
    input("")

q3()

# -- 4
#
# The lambda parameter governs how hard the algorithm is trying to resist disengagement.
# If the parasite population has a strong advantage over the hosts (if their task is much easier), then lambda needs to
# be low, but if the hosts and parasites have an equally challenging task lambda needs to be higher. Since which
# population is enjoying an advantage might change over evolutionary time, it might make sense to have the lambda
# parameter change adaptively to reflect what the balance of power might be at any point in coevolutionary progress.

# -- 5
#
# Many possible answers and approaches here. Q5 is primarily to occupy students who have run out of things do to.





########################
# Parameters and set up:
#
# The following variables parameterise the GA, a default value and a brief description is given for each
#
#    alphabet = "01"                           # this is the set of symbols from which we can build potential solutions
#
#    pop_size = 50                             # the number of individuals in one generation
#    length = 100                              # the length of a solution bit string (both host and parasite)
#    tournament_size = 5                       # the size of the breeding tournament
#    mutation = 0.03                           # the chance that each symbol will be mutated
#
#    coevolution = True                        # flag that determines whether we are doing coeovlution or just evolution
#
#    para_lambda = 1.0                         # the lambda parameter for parasite virulence in range [0.5, 1.0]
#    num_competitions = 10                     # number of tests that a host will face during assessment
#    host_bias = [0.5,0.5]                     # mutation bias for hosts; the default is unbiased mutation "0"s and "1"s are equally likely
#    para_bias = [0.25,0.75]                   # mutation bias for parasites; default is "1"s three times as likely as "0"s
#
#    max_gen  = 600                            # the maximum number of evolutionary generations that will be simulated
#
#    write_every = 10                          # write out some summary stats every x generations - can be useful to set this to 10 or 100 to speed things up, or set it to zero to never write stats
#    file = None                               # write the stats out to a file, or to std out if no file is supplied
#
####################################################################

