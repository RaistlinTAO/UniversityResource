# README
#
# This is the source code for the client assignment.
#
# Read through the (commented) code and try to understand it.

#######################################################################################
# TODO: You can find your group number on CANVAS, eg, if you are group 3, then put "03"
group_number = "00"
#######################################################################################

# import all the required libraries
from opcua import Client
from time import sleep
import numpy as np
import threading
from datetime import datetime
import sys

######################################################################################
# Assign endpoint URL
# Make sure url is same as server url
# TODO: assign correct url and port for client code
url = *
port = *

# Assemble endpoint url
# TODO: assemble the endpoint
end_point = *
######################################################################################

try:
    # Assign endpoint url on the OPC UA client  address space
    client = Client(end_point)

    # Load list of operation request sent by client 1
    Company_1_operation_list = np.loadtxt("Company_1_Operation_List.txt", dtype='str', delimiter=',')

    # Create file instance for client 1 progress file
    Client1_progress_file = open("Group_{}_Progress_Client_1.txt".format(group_number), "w")

    # Create file instance for client 1 Machine Status file
    Client1_Machine_status_file = open("Group_{}_Machine_Status_Client_1.txt".format(group_number), "w")

    # Connect to server
    client.connect()
    # log data
    with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
        ctime = str(datetime.now().time())[:-7]
        f.write("{} - Connecting to OPC UA server \"{}\"\n".format(ctime, end_point))
    print("{} - Connecting to OPC UA server: \"{}\"".format(ctime, end_point))
    sleep(2)
except:
    print("!!!ERROR!!! Please initialise your OPC UA server code first!")
    sys.exit()

# Get the root node of the adress space
objects_node = client.get_objects_node()

# Get the children node of the objects Method
method = objects_node.get_children()

##################################################################################################
# Assign nodes
Equipment_ID1 = client.get_node("ns=2;i=2") # Example
Equipment_ID2 = client.get_node(*)          # TODO: Get a reference to the 'Equipment_ID2' node
Equipment_ID3 = client.get_node(*)          # TODO: Get a reference to the 'Equipment_ID3' node

time_left_conveyor = client.get_node(*)     # TODO: Get a reference to the 'time_left_conveyor' node
time_left_kuka = client.get_node(*)         # TODO: Get a reference to the 'time_left_kuka' node
time_left_Lathe = client.get_node(*)        # TODO: Get a reference to the 'time_left_Lathe' node

current_time = client.get_node(*)           # TODO: Get a reference to the 'current_time' node

Kuka_operation = client.get_node(*)         # TODO: Get a reference to the 'Kuka_operation' node
Lathe_operation = client.get_node(*)        # TODO: Get a reference to the 'Lathe_operation' node

WorkpieceID = client.get_node(*)            # TODO: Get a reference to the 'WorkpieceID' node

Conveyor_Status = client.get_node(*)        # TODO: Get a reference to the 'Conveyor_Status' node
Kuka_Status = client.get_node(*)            # TODO: Get a reference to the 'Kuka_Status' node
Lathe_Status = client.get_node(*)           # TODO: Get a reference to the 'Lathe_Status' node
###################################################################################################



# Flag of switching status
Client1_Machine_status_flag = True
Operation_completion_flag = False

# log data
with open("Group_{}_Machine_Status_Client_1.txt".format(group_number), "a") as f:
    f.write(
        "{:<10}|{:<20}|{:<20}|{:<20}|{:<20}|{:<20}|{:<20}\n".format("Time", "Conveyor Belt", "KUKA Robot", "CNC Lathe",
                                                                    "Workpiece ID", "KUKA Operation",
                                                                    "CNC Lathe Operation"))
    f.write(
        "{:<10}|{:<10}|{:<9}|{:<10}|{:<9}|{:<10}|{:<9}\n".format(" ", "Status", "R_Time", "Status", "R_Time",
                                                                 "Status", "R_Time", )
    )


# function of multithreading logging operation
def Record_machine_status():
    while Client1_Machine_status_flag:

        global Workpiece
        global Current_Operation_log

        Workpiece = WorkpieceID.get_value()

        with open("Group_{}_Machine_Status_Client_1.txt".format(group_number), "a") as f:
            f.write(
                "{:<10}|{:<10}|{:<9}|{:<10}|{:<9}|{:<10}|{:<9}|{:<20}|{:<20}|{:<20}\n".format(current_time.get_value(),
                                                                                              Conveyor_Status.get_value(),
                                                                                              str(time_left_conveyor.get_value())+'s',
                                                                                              Kuka_Status.get_value(),
                                                                                              str(time_left_kuka.get_value()) + 's',
                                                                                              Lathe_Status.get_value(),
                                                                                              str(time_left_Lathe.get_value()) + 's',
                                                                                              Workpiece,
                                                                                              Kuka_operation.get_value(),
                                                                                              Lathe_operation.get_value())
            )

        if Operation_completion_flag:  # Condition to close the operation
            with open("Group_{}_Machine_Status_Client_1.txt".format(group_number), "a") as f:
                f.write("{} Completed!\n".format(Current_Operation_log))
                f.write("-" * 130 + "\n")

        sleep(1)

#############################################################################################
# Assigning method node ID to the variable
Start_Conveyor_prog = method[2]  # Example
Start_Lathe_Prog1 = *            # TODO: Get a reference to the 'Start_Lathe_Prog1' method node
Start_Lathe_Prog2 = *            # TODO: Get a reference to the 'Start_Lathe_Prog2' method node
Start_Kuka_Prog1 = *             # TODO: Get a reference to the 'Start_Kuka_Prog1' method node
#############################################################################################

# Adding and starting a new thread
Add_new_thread = threading.Thread(target=Record_machine_status)
Add_new_thread.start()

# data log
with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
    ctime = str(datetime.now().time())[:-7]
    f.write("{} - Loading operation list\n".format(ctime))
    print("{} - Loading operation list".format(ctime))
    print("There are {} operations from Company 1".format(len(Company_1_operation_list)))
    f.write("There are {} Requests in the Operation List\n".format(len(Company_1_operation_list)))

# Loops for Initiating company's operation list
index = 1
for Current_operation in Company_1_operation_list:

    Operation_completion_flag = False  # Set to true when operation is completed

    # Conveyor and Kuka status check
    while Conveyor_Status.get_value() != "Idle    " or Kuka_Status.get_value() != "Idle    ":
        sleep(1.1)

    # data log
    print("-" * 30 + "OPERATION ({})".format(index) + "-" * 30)
    print("Starting {}".format(Current_operation))
    with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
        f.write("-" * 65 + "\n")
        f.write("Starting {}\n".format(Current_operation))

    # Assigning workpiece data and calling Start_Conveyor_prog on server program
    global Workpiece
    
    #############################################################################################
    # TODO: add code to link conveyor program  start method and pass the current operation detail
    Workpiece = objects_node.call_method(*, *)
    #############################################################################################

    print("{} - Initialising Conveyor Belt".format(current_time.get_value()))

    # data log
    with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
        f.write("{} - Transferring a New Workpiece with ID: {}\n".format(current_time.get_value(), Workpiece))

    # Waiting for conveyor operation to complete
    while time_left_conveyor.get_value() != 0 and Conveyor_Status.get_value() != "Idle    ":
        pass

    # data log
    with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
        f.write("{} - Connecting to KUKA robot\n".format(current_time.get_value()))

    # Conditional loop for different operation
    if Current_operation == "Operation A":  # Operation A

        print("{} - Arriving the Destination on Conveyor Belt".format(current_time.get_value()))

        # Data log
        print("{} - Starting Kuka Robot Operation ---> Pick & Place Started".format(current_time.get_value()))
        with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
            f.write("{} - Starting Kuka Robot Operation ---> Pick & Place Started\n".format(current_time.get_value()))

        #############################################################################################
        # starting Start_Kuka_Prog1 program on kuka
        # TODO: add code to link Start_Kuka_Prog1 program  start method
        return_value_kuka_prog1 = objects_node.call_method(*)
        #############################################################################################

        sleep(1)

        # Waiting for kuka operation to complete
        while time_left_kuka.get_value() != 0 and Kuka_Status.get_value() != "Idle    ":
            pass

        # data log
        print("{} - KUKA Operation Pick & Place Completed".format(current_time.get_value()))
        with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
            f.write("{} - KUKA Operation Pick & Place Completed\n".format(current_time.get_value()))
        sleep(0.5)

        print("{} - Opening CNC Lathe Door".format(current_time.get_value()))
        with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
            f.write("{} - Opening CNC Lathe Door\n".format(current_time.get_value()))
        sleep(1)

        print("{} - Closing CNC Lathe Door".format(current_time.get_value()))
        with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
            f.write("{} - Closing CNC Lathe Door\n".format(current_time.get_value()))
        sleep(1)

        print("{} - Starting Lathe Operation ---> Turning & Drilling".format(current_time.get_value()))
        with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
            f.write("{} - Starting Lathe Operation ---> Turning & Drilling\n".format(current_time.get_value()))
        sleep(1)

        #############################################################################################
        # starting Start_lathe_Prog1 program on Lathe
        # Operation Turning & Drilling
        # TODO: add code to link Start_lathe_Prog1 program  start method
        return_value_lathe_prog1 = objects_node.call_method(*)
        #############################################################################################

        sleep(0.1)

        # Waiting for lathe operation to complete
        while time_left_Lathe.get_value() != 0 and Lathe_Status.get_value() != "Idle    ":
            pass

    elif Current_operation == "Operation B":

        print("{} - Arriving the Destination on Conveyor Belt".format(current_time.get_value()))

        # data log
        print("{} - Starting Kuka Robot Operation ---> Pick & Place Started".format(current_time.get_value()))
        with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
            f.write("{} - Starting Kuka Robot Operation ---> Pick & Place Started\n".format(current_time.get_value()))

        #############################################################################################
        # starting Start_kuka_Prog1 program on kuka
        # TODO: add code to link Start_kuka_Prog1 program  start method
        return_value_kuka_prog1 = objects_node.call_method(*)
        #############################################################################################

        sleep(1)

        # Waiting for kuka operation to complete
        while time_left_kuka.get_value() != 0 and Kuka_Status.get_value() != "Idle    ":
            pass

        # data log
        print("{} - KUKA Operation Pick & Place Completed".format(current_time.get_value()))
        with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
            f.write("{} - KUKA Operation Pick & Place Completed\n".format(current_time.get_value()))
        sleep(0.5)

        print("{} - Opening CNC Lathe Door".format(current_time.get_value()))
        with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
            f.write("{} - Opening CNC Lathe Door\n".format(current_time.get_value()))
        sleep(3)

        print("{} - Closing CNC Lathe Door".format(current_time.get_value()))
        with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
            f.write("{} - Closing CNC Lathe Door\n".format(current_time.get_value()))
        sleep(1)

        print("{} - Starting Lathe Operation ---> Turning & Threading".format(current_time.get_value()))
        with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
            f.write("{} - Starting Lathe Operation ---> Turning & Threading\n".format(current_time.get_value()))
        sleep(1)

        # starting Start_lathe_Prog1 program on lathe
        # Turning & Threading operation
        return_value_lathe_prog2 = objects_node.call_method(Start_Lathe_Prog2)

        sleep(0.1)

        # Waiting for lathe operation to complete
        while time_left_Lathe.get_value() != 0 and Lathe_Status.get_value() != "Idle    ":
            pass

    else:  # invalid operation
        print("!!!ERROR!!! Invalid operation included!\n")
        sys.exit()

    ctime = str(datetime.now().time())[:-7]
    print("{} - {} Completed ".format(ctime, Current_operation))
    index += 1
    with open("Group_{}_Progress_Client_1.txt".format(group_number), "a") as f:
        f.write("{} - {} Completed\n".format(ctime, Current_operation))


    # Storing current operation information in a variable
    global Current_Operation_log
    Current_Operation_log = Current_operation

    # Assigning completion flag
    Operation_completion_flag = True

    sleep(1.1)

# status flag
Client1_Machine_status_flag = False
