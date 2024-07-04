# Calculator in Assembly

This project involves creating a simple calculator using x86 assembly language. The calculator performs the basic arithmetic operations of addition, subtraction, multiplication, and division. The program reads user inputs for two numbers and an operation, then displays the result.

## Assembly Language Calculator

### Main Menu
The program starts with an interactive menu that allows the user to select the operation they wish to perform. Here are the main steps:

1. **Menu Display**: The program displays the available options (addition, subtraction, multiplication, division) and asks the user to make a choice.
2. **Number Input**: After selecting an operation, the user is prompted to enter two numbers.
3. **Operation Execution**: The program performs the chosen operation on the two provided numbers.
4. **Result Display**: The result of the operation is displayed to the user.

### Key Functions
- **SCANHEX**: Reads a character from the keyboard, checks if it's a valid hexadecimal digit, and converts it to its decimal value.
- **SCANINT**: Reads an integer input from the user and converts it into a decimal integer.
- **PRINTINT**: Displays the previously entered characters as a string.
- **FormeNo**: Performs arithmetic operations using registers to store intermediate values and the result.
- **Operations**: Manages the four basic arithmetic operations (addition, subtraction, multiplication, division) and displays the results.

  The report contains scheme for these functions for more understanding.

### Compilation
 Use an assembler compiler to compile the source code, we worked with EMU 8086. follow the simple instructions once its compiled and then it will showcase the result of your chosen operatin. 


For more details on the implementation and functionality of the different functions, please refer to the full project report. **Note**: The report is in French but it more in algorithmics scheme.

---
