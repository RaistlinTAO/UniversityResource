import numpy as np
import matplotlib.pyplot as plt

# Define the function for the main separating line
def f_main(x):
    return 1.25 - 1.1*x

# Three other lines with slight variations in slope and intercept
def f1(x):
    return 1.3 - 0.95*x

def f2(x):
    return 1.2 - 1.15*x

def f3(x):
    return 1.35 - 1.08*x

# Generate random points
num_points = 10

x_red, y_red = [], []
while len(x_red) < num_points:
    x_temp = np.random.rand(1)
    y_temp = np.random.rand(1)
    if y_temp > f_main(x_temp) and y_temp > f1(x_temp) and y_temp > f2(x_temp) and y_temp > f3(x_temp):
        x_red.append(x_temp[0])
        y_red.append(y_temp[0])

x_blue, y_blue = [], []
while len(x_blue) < num_points:
    x_temp = np.random.rand(1)
    y_temp = np.random.rand(1)
    if y_temp <= f_main(x_temp) and y_temp <= f1(x_temp) and y_temp <= f2(x_temp) and y_temp <= f3(x_temp):
        x_blue.append(x_temp[0])
        y_blue.append(y_temp[0])

# Create the figure with specific dimensions
fig, ax = plt.subplots(figsize=(6, 6*(3/4)))

x_vals = np.linspace(0, 1.2, 100)
ax.plot(x_vals, f_main(x_vals), 'k-')
ax.plot(x_vals, f1(x_vals), 'k--')
ax.plot(x_vals, f2(x_vals), 'k--')
ax.plot(x_vals, f3(x_vals), 'k--')

ax.fill_between(x_vals, f_main(x_vals), 2, color="lightgrey")
ax.scatter(x_red, y_red, color="red")
ax.scatter(x_blue, y_blue, color="blue")

ax.set_xlim(0, 1.2)
ax.set_ylim(0, 1.2)
plt.xlabel("$x_1$")
plt.ylabel("$x_2$")

# Save the figure as a PNG
plt.tight_layout()
plt.savefig("random_points.png", dpi=300)

plt.show()
