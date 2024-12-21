# Example definition for data and G
data = rand(25000, 7)
G = rand(7, 7)

code = zeros(25000, 7)

for x = 1:25000
    code[x, :] = (data[x, :])' * G
    code[x, :] .= mod.(code[x, :], 2)
end
