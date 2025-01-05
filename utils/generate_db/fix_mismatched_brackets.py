# Function to fix mismatched closing brackets in a given text
# Groups of characters to check
opening_group = ['[', '(', '«', '﴾']
closing_group = [']', ')', '»', '﴿']

def process_fix_mismatched_brackets(text):
    # Stack to track the expected closing brackets
    stack = []
    fixed_text = []

    # Dictionary to map opening to closing and vice versa
    opening_to_closing = dict(zip(opening_group, closing_group))
    closing_to_opening = dict(zip(closing_group, opening_group))

    for char in text:
        if char in opening_group:
            # Push the expected closing bracket onto the stack
            stack.append(opening_to_closing[char])
            fixed_text.append(char)
        elif char in closing_group:
            if stack and char == stack[-1]:
                # If the character matches the last expected closing bracket, pop it
                stack.pop()
                fixed_text.append(char)
            else:
                # Replace with the correct closing bracket if mismatched
                if stack:
                    correct_char = stack.pop()
                    fixed_text.append(correct_char)
                else:
                    # If no matching opening bracket, skip the character or add a default pair
                    continue
        else:
            # Append other characters as is
            fixed_text.append(char)

    # Add any unmatched opening brackets as closing brackets at the end
    while stack:
        fixed_text.append(stack.pop())

    return ''.join(fixed_text)