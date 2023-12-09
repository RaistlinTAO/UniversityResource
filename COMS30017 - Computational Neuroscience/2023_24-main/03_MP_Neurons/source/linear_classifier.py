import numpy as np
import matplotlib.pyplot as plt

# Define the function for the line
def f(x):
    return 1.25 - 1.1*x

# Generate random points
num_points = 10

x_red, y_red = [], []
while len(x_red) < num_points:
    x_temp = np.random.rand(1)
    y_temp = np.random.rand(1)
    if y_temp > f(x_temp):
        x_red.append(x_temp[0])
        y_red.append(y_temp[0])

x_blue, y_blue = [], []
while len(x_blue) < num_points:
    x_temp = np.random.rand(1)
    y_temp = np.random.rand(1)
    if y_temp <= f(x_temp):
        x_blue.append(x_temp[0])
        y_blue.append(y_temp[0])

# Plot
fig, ax = plt.subplots(figsize=(5, 5*(3/4)))
x_vals = np.linspace(0, 1, 100)
ax.plot(x_vals, f(x_vals), 'k-', label="1.1$x_1$ + $x_2$ = 1.25")
ax.fill_between(x_vals, f(x_vals), 1, color="lightgrey")
ax.scatter(x_red, y_red, color="red", label="Red Points")
ax.scatter(x_blue, y_blue, color="blue", label="Blue Points")
ax.legend()
ax.set_xlim(0, 1)
ax.set_ylim(0, 1)
plt.xlabel("$x_1$")
plt.ylabel("$x_2$")

# Save the figure as a PNG
plt.tight_layout()  # This makes sure that everything fits well within the figure
plt.savefig("linear_classifier.png", dpi=300)  # Save with a resolution of 300 DPI (you can adjust this if needed)


plt.show()
