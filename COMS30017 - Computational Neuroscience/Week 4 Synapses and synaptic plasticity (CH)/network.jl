
#this answers q5 on the worksheet, it is more complicated than is required since it is written
#to be easily extended to a complicated network
#it prints out the voltages and times for ploting elsewhere but you could just make vectors to
#store the values and plot using matplotlib


mutable struct Neuron

    eL::Float64
    vR::Float64
    vT::Float64
    tM::Float64
    iE::Float64

    v::Float64
    
    preSynapses::Vector{Int64}
    postSynapses::Vector{Int64}



end

function makeNeuron(eL::Float64,vR::Float64,vT::Float64,tM::Float64,iE::Float64)
    v=vR+(vT-vR)*rand()
    Neuron(eL,vR,vT,tM,iE,v,[],[])
end
    

function derivative(neuron::Neuron,current::Float64)
    (neuron.eL - neuron.v +neuron.iE + current)/neuron.tM
end

function update!(neuron::Neuron,current::Float64,deltaT::Float64)
    v = neuron.v+derivative(neuron,current)*deltaT
        if v>neuron.vT
            neuron.v=neuron.vR
            return true
        else
            neuron.v=v
            return false
        end
end
    
mutable struct Synapse
    p::Float64
    tS::Float64
    eS::Float64
    gS::Float64
	
    s::Float64

end

function makeSynapse(p::Float64,tS::Float64,eS::Float64,gS::Float64)
    s=rand()
    Synapse(p,tS,eS,gS,s)
end

       
function derivative(synapse::Synapse)
        -synapse.s/synapse.tS
end

function update!(synapse::Synapse,deltaT::Float64)
        synapse.s+=derivative(synapse)*deltaT
end

function spike!(synapse::Synapse)
        synapse.s+=synapse.p
end

function getCurrent(synapse::Synapse,v)
    	synapse.gS*synapse.s*(synapse.eS-v)
end

ms=0.001
mV=0.001

tM=20*ms
eL=-70.0*mV
vR=-80.0*mV
vT=-54.0*mV
iE=18*mV

gS=0.15
p=0.5
tS=10*ms
#eS=0.0*mV
eS=-80.0*mV

nSynapse=2

synapses =[makeSynapse(p,tS,eS,gS) for _ in 1:nSynapse]
    
nNeuron=2

neurons =[makeNeuron(eL,vR,vT,tM,iE) for _ in 1:nNeuron]

push!(neurons[1].preSynapses,1)
push!(neurons[1].postSynapses,2)

push!(neurons[2].preSynapses,2)
push!(neurons[2].postSynapses,1)

t=0
tFinal=1.0

deltaT=1.0*ms

while t<tFinal

    global t
    
    spikes=[]
    for (i,neuron) in enumerate(neurons)
        current=0.0::Float64
        for synapse in neuron.preSynapses
            current+=getCurrent(synapses[synapse],neuron.v)
        end
        if update!(neuron,current,deltaT)
            push!(spikes,i)
        end
    end
        
    for spike in spikes
        for synapse in neurons[spike].postSynapses
            spike!(synapses[synapse])
        end
    end
        
    for synapse in synapses
        update!(synapse,deltaT)
    end
        
    t+=deltaT
    
    println(t," ",neurons[1].v," ",neurons[2].v)

end
