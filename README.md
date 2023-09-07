# London Transportation Challenge

## Description
This Ruby project is a solution to the London Transportation Challenge. It simulates a simple transportation system in London, calculating fares for trips between different stations and updating card balances accordingly. The project includes various Ruby classes for cards, stations, trips, and services to handle these operations.

## Ruby Version
This project was developed using Ruby version 3.2.2.

## How to Run the Script
To run the example script that demonstrates the functionality of the transportation system, follow these steps:

1. Make sure you have Ruby installed on your system.

2. Open your terminal or command prompt.

3. Navigate to the project directory where the `example_script.rb` file is located. (It is in `app/scripts/`).

4. Run the script by executing the following command:

   ```shell
   ruby example_script.rb
   ```

## Example of the script
The script will execute a series of example trips, displaying trip details, card balances, and fare calculations in the terminal.
For example:
```text
Tube Holborn to Earl’s Court (2.50)
328 bus from Earl’s Court to Chelsea (1.80)
Tube Chelsea to Wimbledon (3.20)
```
The total charge is `7.50` and the final card balance will be `22.50`

## How to Run the Tests
To run the tests for this project using RSpec, follow these steps:
Make sure you have RSpec installed on your system. If not, you can install it with:

```shell
gem install rspec
```
- Open your terminal or command prompt.
- Navigate to the project directory where the spec folder is located.
- Run the tests by executing the following command:

```shell
rspec
```
This will run all the tests and display the results in the terminal.
