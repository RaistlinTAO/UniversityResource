# README

# This is the source code for the OPC UA server.

# Read through the (commented) code and try to understand it.

# Please don't modify any code in this file!!!









































# from OPC UA Library to import uamethod and server
# import all the required python libraries
import opcua
from opcua import uamethod
from random import randint
from time import sleep
from datetime import datetime
import threading
import sys
from Generate_Random_Operation_List import Generate_Operation_List

# To generate random operation list for each group
Generate_Operation_List()

# create instance/object of type opcua.Server
myServer = opcua.Server()
current_time = str(datetime.now().time())[:-7]
print("{} - Server instance created...".format(current_time))

# Assign endpoint URL
url = "localhost"  # Localhost
port = 7001  # Port number

endpoint = "opc.tcp://{}:{}".format(url, port)  # Assemble endpoint URL

# Assign endpoint url on the OPC UA server address space
myServer.set_endpoint(endpoint)

# Create a name for OPC UA namespace
name = "OPC UA Assignment"

# Register the name on OPC UA namespace
addSpace = myServer.register_namespace(name)

# Get reference to the Objects node of the OPC UA server
objects = myServer.get_objects_node()

# Create objects on the object node
param = objects.add_object(addSpace, "parameters")

# Create variables for Machine Equipment ID
Equipment_ID1 = param.add_variable(addSpace, "Equipment_ID", "LISMS_Conveyor_LISMS_02")
Equipment_ID2 = param.add_variable(addSpace, "Equipment_ID", "LISMS_KUKA_LISMS_01")
Equipment_ID3 = param.add_variable(addSpace, "Equipment_ID", "LISMS_Lathe_LISMS_04")

# Create variable for Machine Equipment's Leadtime
Conveyor_remaining_time = param.add_variable(addSpace, "remaining_con", "-")
Kuka_remaining_time = param.add_variable(addSpace, "remaining_Kuka", "-")
Lathe_remaining_time = param.add_variable(addSpace, "remaining_Lathe", "-")

# Create variable for Message
Message = param.add_variable(addSpace, "Message", "null")

# Create variable for Timestamp to show current time
TimeStamp = param.add_variable(addSpace, "Time Stamp", "null")

# Create variable for Kuka and Lathe Current Operation
Kuka_Operation = param.add_variable(addSpace, "Current Operation", "null")
Lathe_Operation = param.add_variable(addSpace, "Current Operation", "null")

# Create variable for WorkPiece ID
WorkpieceID = param.add_variable(addSpace, "WorkpieceID", "null")

# Create variable for Equipment's Status
Conveyor_Status = param.add_variable(addSpace, "Status_con", "Idle    ")
Kuka_Status = param.add_variable(addSpace, "Status_Kuka", "Idle    ")
Lathe_Status = param.add_variable(addSpace, "Status_Lathe", "Idle    ")

# Set variable as writable
WorkpieceID.set_writable()

Conveyor_Status.set_writable()
Kuka_Status.set_writable()
Lathe_Status.set_writable()

Message.set_writable()

Conveyor_remaining_time.set_writable()
Kuka_remaining_time.set_writable()
Lathe_remaining_time.set_writable()

TimeStamp.set_writable()

Kuka_Operation.set_writable()
Lathe_Operation.set_writable()

# Create program trigger status flag
Convey_Prog_Start_flag = False
Kuka_Prog1_Start_flag = False
Lathe_Prog1_Start_flag = False
Lathe_Prog2_Start_flag = False
Kuka_Prog2_Start_flag = False


# Methods to execute when an OPC UA client calls a method on the OPC UA server

# Create Method for Conveyor program call
@uamethod
def Start_Conveyor_prog(parent, operation_id):
    # Program to call dummy workpiece from inventory
    # Conditional loop for naming workpiece {(DRL,TRD,MSR) for Drilling ,
    # Threading and Measurement operation}
    if operation_id == "Operation A":
        ID = "DRL"  # Turning and Drilling
    elif operation_id == "Operation B":
        ID = "TRD"  # Turning and Threading
    elif operation_id == "Operation C":
        ID = "MSR"  # Measurement
    else:
        ID = "NIL"  # Nil

    WorkpieceID_var = "WID_" + ID + str(randint(000, 999))  # Random Workpiece name creation (WID_AAA000)

    WorkpieceID.set_value(WorkpieceID_var)  # Write Workpiece ID on workpiece variable

    global Convey_Prog_Start_flag
    Convey_Prog_Start_flag = True

    return WorkpieceID_var


@uamethod
def Start_Lathe_Prog1(parent):
    # Lathe Turning and Drilling Operation
    global Lathe_Prog1_Start_flag
    Lathe_Prog1_Start_flag = True

    return 0


@uamethod
def Start_Lathe_Prog2(parent):
    # Lathe Turning and Threading Operation
    global Lathe_Prog2_Start_flag
    Lathe_Prog2_Start_flag = True

    return 0


@uamethod
def Start_Kuka_Prog1(parent):
    # Kuka pick and place operation
    # Kuka robot picks workpiece from conveyor and places it on Lathe

    global Kuka_Prog1_Start_flag
    Kuka_Prog1_Start_flag = True

    return 0

@uamethod
def Start_Kuka_Prog2(parent):
    # Kuka Measurement Operation
    global Kuka_Prog2_Start_flag
    Kuka_Prog2_Start_flag = True

    return 0


# Create callable methods for program.
# OPC UA server uses method function to send trigger from client to server
objects.add_method(1, "Conveyor", Start_Conveyor_prog)
objects.add_method(1, "Lathe_Prog1", Start_Lathe_Prog1)
objects.add_method(1, "Lathe_Prog2", Start_Lathe_Prog2)
objects.add_method(1, "Kuka_Prog1", Start_Kuka_Prog1)
objects.add_method(1, "Kuka_Prog2", Start_Kuka_Prog2)

# starting! The server will continue running
try:
    current_time = str(datetime.now().time())[:-7]
    print("{} - OPC UA server has been successfully initialised...".format(current_time))
    print("{} - Connect to OPC UA server via \"{}\"...".format(current_time, endpoint))
    myServer.start()
except:
    print("!!!ERROR!!! Failure to initialise the OPC UA server...")
    sys.exit()


# Function for multithreading company 1 Lathe Operation (Turning & Drilling)
def Company1():
    global Lathe_Prog1_Start_flag, Lathe_Prog2_Start_flag
    while True:

        ctime = str(datetime.now().time())[:-7]
        TimeStamp.set_value(ctime)  # Write current time in Timestap server variable

        if Lathe_Prog1_Start_flag:  # Program Turning and Drilling loop
            Lathe_Operation.set_value("Turning")  # write Lathe operation as turning
            for i in range(0, 8):
                # Turning Operation
                Lathe_Status.set_value("Occupied")  # Write Lathe Status
                ctime = str(datetime.now().time())[:-7]
                TimeStamp.set_value(ctime)  # Write current time in Timestap server variable

                Lathe_remaining_time.set_value(str(len(range(1, 8)) - i))  # Write Lathe Operation time left
                sleep(1)
            Lathe_Operation.set_value("null")  # write Lathe operation as Null
            Lathe_Operation.set_value("Drilling")  # write Lathe operation as Drilling
            Lathe_remaining_time.set_value("-")  # Write Lathe Operation time left
            for i in range(0, 5):
                # Drilling Operation
                Lathe_Status.set_value("Occupied")  # Write Lathe Status
                cctime = str(datetime.now().time())[:-7]
                TimeStamp.set_value(ctime)  # Write current time in Timestap server variable

                Lathe_remaining_time.set_value(str(len(range(1, 5)) - i))  # Write Lathe Operation time left
                sleep(1)
            Lathe_Prog1_Start_flag = False
            Lathe_Operation.set_value("null")  # write Lathe operation as Null
            Lathe_remaining_time.set_value("-")  # Write Lathe Operation time left

            Lathe_Status.set_value("Idle    ")  # Write Lathe Status

        if Lathe_Prog2_Start_flag:
            Lathe_Operation.set_value("Turning")  # write Lathe operation
            for i in range(0, 8):
                # Turning Operation
                Lathe_Status.set_value("Occupied")  # Write Lathe Status
                ctime = str(datetime.now().time())[:-7]
                TimeStamp.set_value(ctime)  # Write current time in Timestap server variable

                Lathe_remaining_time.set_value(str(len(range(1, 8)) - i))  # Write Lathe Operation time left
                sleep(1)
            Lathe_Operation.set_value("null")  # write Lathe operation
            Lathe_Operation.set_value("Threading")  # write Lathe operation
            Lathe_remaining_time.set_value("-")  # Write Lathe Operation time left
            for i in range(0, 6):
                # Drilling Operation
                Lathe_Status.set_value("Occupied")  # Write Lathe Status
                ctime = str(datetime.now().time())[:-7]
                TimeStamp.set_value(ctime)  # Write current time in Timestap server variable

                Lathe_remaining_time.set_value(str(len(range(1, 6)) - i))  # Write Lathe Operation time left
                sleep(1)
            Lathe_Prog2_Start_flag = False
            Lathe_Operation.set_value("null")  # write Lathe operation
            Lathe_remaining_time.set_value("-")  # Write Lathe Operation time left

            Lathe_Status.set_value("Idle    ")  # Write Lathe Status


New_thread1 = threading.Thread(target=Company1)
New_thread1.start()

# Main thread for running Company 1&2 Kuka and Conveyor operation
while True:
    ctime = str(datetime.now().time())[:-7]
    TimeStamp.set_value(ctime)  # Write current time in Timestap server variable

    if Convey_Prog_Start_flag:

        for i in range(0, 5):
            Conveyor_Status.set_value("Occupied")  # write Conveyor Status

            Conveyor_remaining_time.set_value(str(len(range(1, 5)) - i))  # Write Conveyor Operation time left

            ctime = str(datetime.now().time())[:-7]
            TimeStamp.set_value(ctime)  # Write current time in Timestap server variable
            sleep(1)
        Convey_Prog_Start_flag = False
        Conveyor_Status.set_value("Idle    ")  # write Conveyor Status
        Conveyor_remaining_time.set_value("-")  # Write Conveyor Operation time left

    if Kuka_Prog1_Start_flag:
        Kuka_Operation.set_value("Pickup")  # write Kuka operation
        for i in range(0, 6):
            Kuka_Status.set_value("Occupied")  # write Kuka Status
            ctime = str(datetime.now().time())[:-7]
            TimeStamp.set_value(ctime)  # Write current time in Timestap server variable

            Kuka_remaining_time.set_value(str(len(range(1, 6)) - i))  # Write kuka Operation time left
            sleep(1)
        Kuka_Prog1_Start_flag = False
        Kuka_Status.set_value("Idle    ")  # write Kuka Status
        Kuka_Operation.set_value("null")  # write Kuka operation
        Kuka_remaining_time.set_value("-")  # Write kuka Operation time left

    if Kuka_Prog2_Start_flag:
        Kuka_Operation.set_value("Measurement")  # write Kuka operation
        for i in range(0, 6):
            Kuka_Status.set_value("Occupied")  # write Kuka Status
            ctime = str(datetime.now().time())[:-7]
            TimeStamp.set_value(ctime)  # Write current time in Timestap server variable

            Kuka_remaining_time.set_value(str(len(range(1, 6)) - i))  # Write kuka Operation time left
            sleep(1)
        Kuka_Prog2_Start_flag = False
        Kuka_Status.set_value("Idle    ")  # write Kuka Status
        Kuka_Operation.set_value("null")  # write Kuka operation
        Kuka_remaining_time.set_value("-")  # Write kuka Operation time left
