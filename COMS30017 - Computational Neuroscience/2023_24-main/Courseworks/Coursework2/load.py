import ast,re

def load_points(filename):
    
    with open(filename, 'r') as file:
        points=[]
        for line in file:
            label, point_str = line.strip().split(maxsplit=1)
            
            point_str = re.sub(r'\s+', ',', point_str)
            point = ast.literal_eval(point_str)
            
            points.append([label,point])
    
    return points

points=load_points("points.txt")
for point in points:
    print(point)
