#
# This is the example server code.
#
# Read through the (commented) code and try to understand it.

import opcua
from time import sleep
from random import randint
from datetime import datetime

# Assign endpoint URL
url = "localhost"
port = 5001
endpoint = "opc.tcp://{}:{}".format(url, port)

# create instance/object of type opcua.Server
myserver = opcua.Server()

# Assign endpoint url on the OPC UA server address space
myserver.set_endpoint(endpoint)

# Create a name for OPC UA namespace
name = "Temperature Sensor"

# Register the name on OPC UA namespace
addspace = myserver.register_namespace(name)

# Get reference to the Objects node of the OPC UA server
objects = myserver.get_objects_node()

# Create objects on the object node
param = objects.add_object(addspace, "parameters")

# Create variables
Sensor_name = param.add_variable(addspace, "Sensor Name", "Temperature_Sensor_SF12")
Temperature = param.add_variable(addspace, "Temperature Value", 'NA')

# Set variable as writable
Sensor_name.set_writable()
Temperature.set_writable()

#########################################################################################
# Present the data structure of the OPC UA server
root = myserver.get_root_node()
print("Root Node Id: %s" % root)
print("Children of root are: %s" % root.get_children())
print()

my_objects = myserver.get_objects_node()
print("Defined object Node Id: %s" % my_objects)
print("Children of the defined object are: %s" % my_objects.get_children())
print()

sensor_name_node = my_objects.get_children()[1].get_children()[0]
print("Sensor name node Id: %s" % sensor_name_node)
print("Sensor name node browse name: %s" % sensor_name_node.get_browse_name())
print("Sensor name default value: %s" % sensor_name_node.get_value())
print()

temperature_node = my_objects.get_children()[1].get_children()[1]
print("Temperature node Id: %s" % temperature_node)
print("Temperature node browse name: %s" % temperature_node.get_browse_name())
print("Temperature default value: %s" % temperature_node.get_value())
print()
########################################################################################

# starting! The server will continue running
myserver.start()
current_time = str(datetime.now().time())[:-7]
print("{} - Server is initialising...".format(current_time))

while True:
    sleep(5)
    current_time = str(datetime.now().time())[:-7]
    current_temp = randint(10, 25)

    Temperature.set_value(current_temp)  # publish temperature value
    print("{} - Current temperature: {} Celsius".format(current_time, current_temp))
