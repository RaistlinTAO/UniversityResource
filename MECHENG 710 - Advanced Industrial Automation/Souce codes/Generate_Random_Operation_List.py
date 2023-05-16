import random

def Generate_Operation_List():
    print("good")
    with open("Company_1_Operation_List.txt", "w") as f:
        for row in range(5):
            randNum = random.randint(0, 1)
            if randNum == 0:
                f.write("Operation A\n")
            else:
                f.write("Operation B\n")

    with open("Company_2_Operation_List.txt", "w") as f:
        for row in range(4):
            f.write("Operation C\n")

Generate_Operation_List()