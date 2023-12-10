import matplotlib as mpl          # we use matplotlib to generate the nice plots
import matplotlib.pyplot as plt   # we use matplotlib to generate the nice plots
import textwrap                   # we use this to format the chart title

# see end of file for some examples of how to use these functions to make plots..

# Note: To get the full xkcd effect, you need the Humor Sans MPL font:
#   You can get it from  here: https://seis.bristol.ac.uk/~sb15704/HumorSansMPL.ttf
# (I added a couple of missing glyphs to fix a font problem caused by a matplotlib bug.)

def set_font_and_size(width=9,height=7):
    mpl.rcParams['font.family'] = ['Humor Sans MPL']  # use the xkcd font with missing characters included
    mpl.rcParams['figure.figsize'] = [width, height]  # and set the plot size (default: 9" x 7")


# because matplotlib doesn't automatically split long titles over multiple lines
# the first line of code here splits 'title' into a list of max-30-letter chunks
# and then joins them back up with newline characters
def split_title(title):
    return "\n".join(textwrap.wrap(title,32))


# takes numerical values (data) and a title and axis labels and produces an xkcd-styled histogram
# data can be one list of values or a list containing multiple series of values
# in the latter case you must use the labels argument to specify the name of each data series
# you can override the default no. bins, column widths and transparency using the bins, width and alpha arguments
# the plot will be shown on the screen and dumped to disc in a file with the same name as the plot's title
def make_a_histogram(data=[], title="", xlabel="Axis Unlabelled!", ylabel="Axis Unlabelled!",
                     labels=None, bins=None, width=None, alpha=None):

    with plt.xkcd(): # use the nice xkcd plot style

        set_font_and_size()   # use the nice font and a nice size

        plt.title(split_title(title)) # set the plot title

        plt.xlabel(xlabel) # set the x axis label
        plt.ylabel(ylabel) # set the y axis label

        plt.hist(data, rwidth=width, bins=bins, alpha=alpha, label=labels)

        if labels: #if there are multiple datasets to plot...
            width = width or 1/len(labels) # unless column width is specified already make it relative to no. series
            alpha = alpha or 1 # unless column transparency is specified already set columns to be semi-transparent
            plt.legend()
        else:
            width = width or 1 # unless column width is specified already set it to 1
            alpha = alpha or 1 # unless column transparency is specified already set it to fully opaque

        plt.tight_layout()         # make sure the plot has room for the axis labels and title
        plt.savefig(title+".pdf")  # ..and save it to a file
        plt.show()                 # put the plot on the screen


# takes two equal-length lists of numerical values (x and y) and a title and axis labels and produced an xkcd styled line plot of y against x
# y can also be a list containing several list of data, each of which will be plotted separately
# in this case labels should contain a list of the names of each data series
# the plot will be shown on the screen and dumped to disc in a file with the same name as the plot's title
# the x axis is assumed to be log scaled unless log_xscale is specified to be False in the function call
def make_a_line_plot(x=[], y=[], title="", xlabel="Axis Unlabelled!", ylabel="Axis Unlabelled!", log_xscale=True, ylim=None, labels=None):

    with plt.xkcd(): # use the nice xkcd plot style

        set_font_and_size()   # use the nice font and a nice size

        plt.title(split_title(title)) # set the plot title

        plt.xlabel(xlabel) # set the x axis label
        plt.ylabel(ylabel) # set the y axis label

        if log_xscale:
            plt.xscale('log')

        if ylim:
            bottom,top = ylim
            plt.ylim(bottom=bottom, top=top) # set the yaxis to range from bottom to top

        if isinstance(y[0],list):
            for s in range(len(y)):
                plt.plot(x,y[s],label=labels[s])
            plt.legend()
        else:
            plt.plot(x, y)

        plt.tight_layout()         # make sure the plot has room for the axis labels and title
        plt.savefig(title+".pdf")  # ..and save it to a file
        plt.show()                 # put the plot on the screen


# takes in the x, y and z coords of points to scatter over the plot
# generates a scatter plot of y against x, with z used to colour the markers
def make_a_scatter_plot(x=[], y=[], z=[], labels=[], ylim=None, log_xscale=False, log_yscale=False,
                        title="", xlabel="Axis Unlabelled!", ylabel="Axis Unlabelled!", zlabel="Axis Unlabelled!"):

    with plt.xkcd(): # use the nice xkcd plot style

        set_font_and_size()   # use the nice font and a nice size

        plt.title(split_title(title)) # set the plot title

        plt.xlabel(xlabel) # set the x axis label
        plt.ylabel(ylabel) # set the y axis label

        if log_xscale:
            plt.xscale('log')

        if log_yscale:
            plt.yscale('log')

        if ylim:
            bottom, top = ylim
            plt.ylim(bottom=bottom, top=top)       # set the yaxis to range from bottom to top

        # cm = mpl.colormaps.get_cmap('viridis_r')    # choose a color map
        cm = mpl.colormaps.get_cmap('RdYlBu_r')    # choose a color map
        if isinstance(y[0],list):
            sc = [None]*len(y)
            zmin = min(min(z, key=min))
            zmax = max(max(z, key=max))
            if len(labels) != len(y):
                print("The right number of labels was not provided...")
                labels = ["Label "+str(s+1)  for s in range(len(y)) ]
            for s in range(len(y)):                    # for each data set...
                marker = ['o', 'x', 'D', '*'][s]       # set the scatter plot marker symbol
                offset = (max(set(x[s]))-min(set(x[s])))/(2*len(set(x[s]))) # updated..
                # plot the markers:
                sc[s] = plt.scatter([pos+s*offset for pos in x[s]], y[s], c=z[s], s=150, marker=marker, cmap=cm, label=labels[s], vmax=zmax, vmin=zmin)
                # note: we shift each series of markers slightly to the right to avoid them cluttering the previous series
                sc[s].set_alpha(0.25)                   # uncommented | set the markers to be somewhat transparent

            plt.legend()                            # add the legend
        else:
            sc = [plt.scatter(x, y, c=z, cmap=cm, s=150)]

        cbar = plt.colorbar(sc[0])              # add a colour bar
        cbar.ax.set_ylabel(zlabel, rotation=90) # rotate the colour bar label
        cbar.solids.set(alpha=1)                # set the colour bar colour to not be transparent

        filename = "".join([c for c in title if c.isalpha() or c.isdigit() or c==' ']).strip()

        plt.tight_layout()         # make sure the plot has room for the axis labels and title
        plt.savefig(filename+".png")  # ..and save it to a file
        plt.show()                 # put the plot on the screen


def examples():

    f1 = [-1.427, -1.501, -0.659, 0.488, -0.381, 0.567, -2.598, -1.319, 0.576, -1.288, 0.544, -0.275, 0.749, -0.682, -1.513, 0.092, -0.689, 1.191, 0.041, -0.559, -0.254, 0.339, -0.962, 0.957, 1.605, -0.932, -1.443, -0.345, 0.783, -0.239, 0.801, -1.806, -0.87, 0.675, 0.575, -1.081, 1.366, -0.863, 1.363, -0.129, 0.105, -1.298, -1.101, 0.063, 0.973, 0.733, -0.438, 1.312, 1.195, 0.111]

    make_a_histogram(f1, title="An Example Histogram", xlabel="The x axis label", ylabel="The y axis label")
    input("[Hit return to continue]\n")

    f2 = [0.565, 0.763, 2.895, 1.81, 0.947, 1.15, -0.91, 0.31, 1.903, 1.38, 1.281, 0.198, 1.722, 1.272, 0.921, 0.311, 0.356, 2.661, 0.648, 2.158, 1.884, 0.73, -0.095, -0.525, 1.356, 1.842, 2.531, 0.335, 1.253, 0.373, 1.161, 0.31, 1.017, 2.107, 1.777, 0.837, 1.347, 1.413, 0.06, 2.68, 0.17, 0.173, 0.471, 3.22, 2.521, 0.383, -0.559, 1.511, 0.538, 1.456]

    make_a_histogram([f1,f2], title="An Example Histogram With Multiple Datasets",
                     xlabel="The x axis label", ylabel="The y axis label", labels=["Normal", "Better"])
    input("[Hit return to continue]\n")

    x = [0, 10, 20, 30, 40, 50 , 60, 70, 80, 90, 100]
    y1 = [0.083, 0.085, 0.297, 0.447, 0.419, 0.557, 0.482, 0.61, 0.81, 1.008, 0.964]

    make_a_line_plot(x, y1, title="An Example Plot", xlabel="The x axis label", ylabel="The y axis label",
                     log_xscale=False)
    input("[Hit return to continue]\n")

    y2 = [1.024, 0.91, 0.697, 0.735, 0.733, 0.598, 0.478, 0.285, 0.313, 0.021, -0.013]

    make_a_line_plot(x, [y1,y2], title="An Example Plot With Multiple Datasets",
                     xlabel="The x axis label", ylabel="The y axis label",
                     labels=["Going up","Going down"])
    input("[Hit return to continue]\n")

    make_a_scatter_plot(x, y1, y2, title="An Example Scatter",
                        xlabel="The x axis label", ylabel="the y axis label", zlabel="The colour label")
    input("[Hit return to continue]\n")

    y3 = [0.567, 0.486, 0.475, 0.527, 0.559, 0.445, 0.502, 0.506, 0.479, 0.46, 0.421]

    z1 = [1.083, 0.985, 1.097, 1.147, 1.019, 1.057, 0.882, 0.91, 1.01, 1.108, 0.964]
    z2 = [2.024, 1.81, 1.497, 1.435, 1.333, 1.098, 0.878, 0.585, 0.513, 0.121, -0.013]
    z3 = [1.567, 1.386, 1.275, 1.227, 1.159, 0.945, 0.902, 0.806, 0.679, 0.56, 0.421]

    make_a_scatter_plot([x, x, x], [y1, y2, y3], [z1, z2, z3],
                        title="An Example Scatter with Multiple Datasets",
                        xlabel="The x axis label", ylabel="the y axis label", zlabel="The colour label",
                        labels=["Series 1", "Series 2", "Series 3"])
    input("[Hit return to continue]\n")

    print("Finished!")

# to generate the examples uncomment the following line of code:
# examples()