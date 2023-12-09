import numpy as np

# Function to determine if the point is 'red' or 'blue' based on the condition
def is_red(point):
    return point[0] - 2*point[1] + 1.2*point[2] - point[3] + 0.5*point[4] > 2

# Generating points
red_points = []
blue_points = []

#scale=10.0
scale=1.0

n=100

while len(red_points) < n or len(blue_points) < n:
    point = np.random.rand(5) * scale 
    if is_red(point) and len(red_points) < n:
        red_points.append(point)
    elif not is_red(point) and len(blue_points) < n:
        blue_points.append(point)

# Combining the points
all_points = [("red", point) for point in red_points] + [("blue", point) for point in blue_points]

# Display the points

for label, point in all_points:
    print(label, point)
