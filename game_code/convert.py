# Specify the bit-width for two's complement representation
BIT_WIDTH = 32
MAX_VAL = 2 ** BIT_WIDTH

# Open the input file and read its contents
with open('bird_code/even_simpler.sq', 'r') as infile:
    data = infile.read()

# Split the data into individual numbers
numbers = data.split()

# Convert each number to two's complement hexadecimal
hex_numbers = []
for num in numbers:
    value = int(float(num))  # Convert to integer
    if value < 0:  # Handle negative numbers
        value = MAX_VAL + value  # Add 2^n to represent in two's complement
    hex_numbers.append(f"{value:0{BIT_WIDTH // 4}x}")  # Format to hexadecimal

for i in range(5000):
    hex_numbers.append("00000000")

# Join the hexadecimal numbers with newlines
output = '\n'.join(hex_numbers)

# Write the output to a new file
with open('../even_simpler.hex', 'w') as outfile:
    outfile.write(output)

print("Conversion complete. Check 'output.txt'.")

