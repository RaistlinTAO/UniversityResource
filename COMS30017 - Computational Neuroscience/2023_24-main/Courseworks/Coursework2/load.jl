function load_points(filename)
    points_dict = Dict{NTuple{5, Float64}, String}()
    
    open(filename, "r") do file
        for line in eachline(file)
            parts = split(replace(line, ['[', ']'] => ""))
            label = parts[1]
            point_values = [parse(Float64,parts[i]) for i in 2:6]
            point=tuple(point_values...)
            points_dict[point] = label
        end
    end
    
    return points_dict
end

# Test the function
points_dict = load_points("points.txt")

# Display the loaded points and labels
for (point, label) in points_dict
    println("$point -> $label")
end
