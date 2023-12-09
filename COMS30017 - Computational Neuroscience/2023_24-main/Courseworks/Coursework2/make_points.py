import numpy as np

# Function to determine if the point is 'red' or 'blue' based on the condition
def is_red(point):
    return point[0] - 2*point[1] + 1.2*point[2] - point[3] + 0.5*point[4] > 2

# Generating points
red_points = []
blue_points = []

while len(red_points) < 10 or len(blue_points) < 10:
    point = np.random.rand(5) * 10  # Generating 5D points with values between 0 and 10
    if is_red(point) and len(red_points) < 10:
        red_points.append(point)
    elif not is_red(point) and len(blue_points) < 10:
        blue_points.append(point)

# Combining the points
all_points = [("red", point) for point in red_points] + [("blue", point) for point in blue_points]

# Display the points

for label, point in all_points:
    print(label, point)
