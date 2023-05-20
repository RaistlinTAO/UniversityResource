#
# This is the example client code.
#
# Read through the (commented) code and try to understand it.

from opcua import Client
from datetime import datetime

# Assign endpoint URL
url = "localhost"
port = 5001
endpoint = "opc.tcp://{}:{}".format(url, port)

# Assign endpoint url on the OPC UA client  address space
myclient = Client(endpoint)

# Connect to server
myclient.connect()

# Assign nodes
Temperature_node = myclient.get_node("ns=2;i=3")

# Subhandler Class from OPC UA
class SubHandler(object):
    """
    Subscription Handler. To receive events from server for a subscription
    """

    def datachange_notification(self, node, val, data):
        """
        called for every datachange notification from server
        """
        global DataChange  # Global variable
        current_time = str(datetime.now().time())[:-7]
        DataChange = val  # Assigning value to global variable
        print("{} - Received temperature: {} Celsius".format(current_time, val))

    # Initailise variable


nodes = myclient.get_objects_node()
DataChange = "null"

# Create Sub handler
handler = SubHandler()

# create subscription by passing period in milliseconds and handler
subscribe = myclient.create_subscription(0, handler)

# pass variable node to subscribe data change method
handler = subscribe.subscribe_data_change(Temperature_node)
