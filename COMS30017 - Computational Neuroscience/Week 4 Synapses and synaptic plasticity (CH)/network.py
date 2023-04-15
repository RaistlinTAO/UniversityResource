# this answers q5 on the worksheet, it is more complicated than is required since it is written
# to be easily extended to a complicated network
# it prints out the voltages and times for ploting elsewhere but you could just make vectors to
# store the values and plot using matplotlib


from random import *


class Neuron:

    def __init__(self, e_l, v_r, v_t, t_m, i_e):
        self.e_l = e_l
        self.v_r = v_r
        self.v_t = v_t
        self.t_m = t_m
        self.i_e = i_e

        self.pre_synapses = []
        self.post_synapses = []

        self.v = self.v_r + (self.v_t - self.v_r) * uniform(0.0, 1.0)

    def derivative(self, current):
        return (self.e_l - self.v + self.i_e + current) / self.t_m

    def update(self, current, delta_t):
        self.v += self.derivative(current) * delta_t
        if self.v > self.v_t:
            self.v = self.v_r
            return True
        else:
            return False


class Synapse:

    def __init__(self, p, t_s, e_s, g_s):
        self.p = p
        self.t_s = t_s
        self.e_s = e_s
        self.g_s = g_s

        self.s = uniform(0.0, 1.0)

    def derivative(self):
        return -self.s / self.t_s

    def update(self, delta_t):
        self.s += self.derivative() * delta_t

    def spike(self):
        self.s += self.p

    def get_current(self, v):
        return self.g_s * self.s * (self.e_s - v)


ms = 0.001
mV = 0.001

t_m = 20 * ms
e_l = -70.0 * mV
v_r = -80.0 * mV
v_t = -54.0 * mV
i_e = 18 * mV

g_s = 0.15
p = 0.5
t_s = 10 * ms
# e_s=0.0*mV
e_s = -80.0 * mV

n_synapse = 2

synapses = [Synapse(p, t_s, e_s, g_s) for _ in range(n_synapse)]

n_neuron = 2

neurons = [Neuron(e_l, v_r, v_t, t_m, i_e) for _ in range(n_neuron)]

neurons[0].pre_synapses.append(0)
neurons[0].post_synapses.append(1)

neurons[1].pre_synapses.append(1)
neurons[1].post_synapses.append(0)

t = 0
t_final = 1.0

delta_t = 1.0 * ms

while t < t_final:

    spikes = []
    for neuron in neurons:
        current = 0.0
        for synapse in neuron.pre_synapses:
            current += synapses[synapse].get_current(neuron.v)
        if neuron.update(current, delta_t):
            spikes.append(neuron)

    for spike in spikes:
        for synapse in spike.post_synapses:
            synapses[synapse].spike()

    for synapse in synapses:
        synapse.update(delta_t)

    t += delta_t

    print(t, neurons[0].v, neurons[1].v)
