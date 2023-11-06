def check_good_string(binary_string):
    """
    Checks if the given binary string is a good binary string.
    A good binary string is a string that has the property:
      - For every prefix, the number of 1's should not be less than the number of 0's.
      - Total number of 0s should be equal to number of 1s.
    """

    count_ones = 0
    count_zeros = 0

    for char in binary_string:
        if char == '1':
            count_ones += 1
        elif char == '0':
            count_zeros += 1
        else:
            raise ValueError('Invalid binary string')

        if count_ones < count_zeros:
            return False

    return count_zeros == count_ones


def find_largest_good_string(prefix, binary_string, cur_large_value):
    """
    Finds the largest binary string value in the given binary string recursively.
    """

    # Terminal state. Minimum length of a good binary string is 2.
    if len(binary_string) < 2:
        return cur_large_value

    # Split the binary string into good substrings
    good_substrings = []
    current_substring = ""

    for char in binary_string:
        current_substring += char

        if check_good_string(current_substring):
            good_substrings.append(current_substring)
            current_substring = ""

    # Sort the good substrings in reverse order to get the largest ones first
    good_substrings.sort(reverse=True)

    # Reconstruct the largest good string by joining the sorted substrings and if any suffix.
    largest_good_string = prefix + "".join(good_substrings) + current_substring

    good_string_value = int(largest_good_string, 2)

    if good_string_value > cur_large_value:
        cur_large_value = good_string_value

    return find_largest_good_string(prefix + binary_string[0], binary_string[1:], cur_large_value)


# Tests
binary_strings = ["1010111000", "11011000", "1100", "1101001100"]
expected_outputs = ["1110001010", "11100100", "1100", "1101001100"]

for i in range(len(binary_strings)):
    if not check_good_string(binary_strings[i]):
        raise ValueError(f'{binary_strings[i]} is not a good binary string')

    largest_good_string = format(find_largest_good_string("", binary_strings[i], 0), 'b')
    print(f'Largest Good string for {binary_strings[i]}:{largest_good_string}')
    assert largest_good_string == expected_outputs[i], f'For input:{binary_strings[i]}, Expected:{expected_outputs[i]}, Actual:{largest_good_string}'