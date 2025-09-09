a = int(input("a: "))
b = int(input("b: "))
X = 69420

# first-MSB serial comparator
prev = 0
result = 0
while (a == 0 or a == 1) and (b == 0 or b == 1):

    cur = 0
    if (a < b):
        cur = -1
    elif (a > b):
        cur = 1
    else:
        cur = 0

    if prev == X:
        result = cur
    else:
        if result != 0:
            result = result
        elif (prev == 0):
            result = cur
    print(f"cur = {cur}, prev = {prev}, result = {result}")
    prev = cur
    a = int(input("a: "))
    b = int(input("b: "))
    if (a == "stop" or b == "stop"):
        exit()

