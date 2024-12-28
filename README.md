# Branch Predictors Hardware Models

* In this repo I have implemented four branch prediction models of two types.

* These two types are 'Direction based Predictors' and 'History based Predictors'.

* In Direction based Predictors types 'one bit direction predictor' and 'two bit direction predictor' are implemented.

* In History based Predictors types 'G share Branch Predictor'  and 'P share Branch Predictor' are implemented.


## one bit direction predictor

* The BHT table has been implemented with 128 entries, and prediction bit is 1 bit. '0' for Not taken and '1' for taken.

* The BTB has been implemented with 32 entries, it can store the address tag and branch offset.

* It has been tested for the patterns "TTTTNNNN" and "TNTNTNTN".


## two bit direction predictor

* The BHT table has been implemented with 128 entries, and prediction bits are 2 bits. 

* '00' for Strongly Not taken, '01' for Weakly Not taken, '10' for Weakly taken, '11' for Strongly taken

* The BTB has been implemented with 32 entries, it can store the address tag and branch offset.

* It has been tested for the patterns "TTTTNNNN" and "TNTNTNTN".

## G share history based predictor

* GHSR register is 8 bits long.

* The BHT table has been implemented with 256 entries, and prediction bits are 2 bits. 

* '00' for Strongly Not taken, '01' for Weakly Not taken, '10' for Weakly taken, '11' for Strongly taken.

* GHSR is XORed with PC and then mapped to BHT.

* It has been tested for pattern 'NNNNNNNT'

## P share history based predictor

* PHT table has four entries and is four bits wide.

* Each PHT entry has a personal BHT table with 16 entries with 2 bits for prediction.

* There are total 4 BHT tables with 16 entries each.

* BTB is with 256 entries, can store tag and branch offset.

* PHT is mapped to BHT, PC is mapped to BTB.

* Four patterns are tested at a time. 'NNNT' , 'NNTN', 'NTNN', 'TNNN' one for each entry in PHT.

## tools used

### for verilog simulation and testing
    > Icarus Verilog

### Debug
    > gtkwave
    
### Lint
    > verilator

