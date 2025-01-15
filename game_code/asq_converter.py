'''

asq_converter.py:

    Converts assembled higher subleq code to the .hex format needed
    for loading the FPGA ROMs via Vivado.

'''

# import shit
import argparse # read terminal inputs
import re # make pig sounds
import pprint # make nice array prints

# do shit
def main():

    # read in arguments for input/output files
    parser = argparse.ArgumentParser(
                    prog="ASQ Converter",
                    description='''Converts assembled higher subleq code to the 
                                   .hex format needed for loading the FPGA ROMs 
                                   via Vivado.Use good filenames and that 
                                   kind of thing. I'm not writing useful 
                                   checks.''')
    parser.add_argument('input_filename')
    parser.add_argument('output_filename')
    parser.add_argument('-v', '--verbose',
                        action='store_true')  # on/off flag    
    
    args = parser.parse_args()
    input_filename = args.input_filename
    output_filename = args.output_filename
    verbose = args.verbose

    # read input file as string
    try: 
        file = open(input_filename, "r")
        read_string = file.read()
        file.close()
    except: 
        print(f"something went wrong. you did bad.")
        exit

    print() # blank line heeheehawhaw
    if verbose:
        print(f"successfully read in file {input_filename} and found")
        print(f"{read_string}")

    # generate array of values via string split
    values_array_str = re.split(' |\n', read_string) # split along spaces, \n

    print() # blank line heeheehawhaw
    if verbose:
        print(f"read string became array with strings")
        pprint.pprint(values_array_str)

    values_array_int = []
    for str_value in values_array_str: # make into int
        if str_value != "": # I dunno why split does this whatever
            values_array_int.append(int(str_value))

    print() # blank line heeheehawhaw
    if verbose:
        print(f"converted all str values to int to get")
        pprint.pprint(values_array_int)

    values_array_str_hex = []
    for int_value in values_array_int:
        values_array_str_hex.append(f"{str(f'{int_value:0x}')}")

    print() # blank line heeheehawhaw
    if verbose:
        print(f"converted all int values to str(hex) form to get")
        pprint.pprint(values_array_str_hex)

    # write each of the values (hex-converted) to the output files
    hex_string = "\n".join(values_array_str_hex)
    
    print() # blank line heeheehawhaw
    if verbose:
        print(f"concatenated these with newlines to get: {hex_string}")
        print(f"which will now be written to {output_filename}")

    try: 
        file = open(output_filename, "w")
        file.write(hex_string)
        file.close()
    except: 
        print(f"something went wrong. you did bad.")
        exit

    print() # blank line heeheehawhaw
    if verbose:
        print(f"successfully wrote to file {output_filename}. done now.")

main()



