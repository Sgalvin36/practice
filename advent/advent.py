with open('advent1.txt', 'r') as f:
    output = f.read()
    
    for i in output:
        data_points = []
        data_points[i] = i
        print(data_points[i])