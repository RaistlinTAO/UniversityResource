import random
import ast,re
import matplotlib.pyplot as plt

def load_points(filename):
    
    with open(filename, 'r') as file:
        points=[]
        for line in file:
            label, point_str = line.strip().split(maxsplit=1)
            
            point_str = re.sub(r'\s+', ',', point_str)
            point = ast.literal_eval(point_str)
            
            points.append([label,point])
    
    return points


def find_d(color):
    if color=="red":
        return 1
    else:
        return -1


class Perceptron:

    def __init__(self,n,eta):
        self.w=[0.0 for _ in range(0,n)]
        self.theta=0.0
        self.eta=eta
        self.average_error=1.0

    def predict(self,x):
        value=0.0
        for i,input in enumerate(x):
            value+=self.w[i]*input
        if value>self.theta:
            return 1
        else:
            return -1

    def learn(self,point):
        d=find_d(point[0])
        x=point[1]
        y=self.predict(x)
        print(d,y)
        error=d-y #if the prediction is too small this is positive
        for i,input in enumerate(x):
            self.w[i]+=eta*input*error #a bigger w makes the prediction bigger
        self.theta+=-eta*error #smaller theshold will make prediction bigger
        self.average_error=0.9*self.average_error+0.1*abs(error)
        

    def normalize(self):
        for weight in self.w:
            weight/=self.theta
        self.theta=1.0
        
    def print_perceptron(self):
        for i,weight in enumerate(self.w):
            print(round(weight,2),"x_",i+1,sep="",end="")
            if i!=len(self.w)-1 and self.w[i+1]>0:
                print("+",end="")
        print("=",round(self.theta,2),sep="")
            
        
n=5
eta=0.01

points=load_points("point_harder.txt")

trial_n=2000

perceptron=Perceptron(n,eta)

errors=[]

for _ in range(trial_n):
    
    perceptron.learn(random.choice(points))
    #perceptron.print_perceptron()
    errors.append(perceptron.average_error)

print(perceptron.average_error)
perceptron.normalize()
perceptron.print_perceptron()
#plt.plot(errors)
#plt.show()


