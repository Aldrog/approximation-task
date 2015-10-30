# Task
For function `f(x) = x cos(x + 3)` find:  
1. Degree 3 polynomial of best approximation with least squares method on 5 nodes in `[-1; 1]`.  
2. Degree 3 polynomial of best approximation on L2 space with Legendre polynomials in the same interval.  

#Result
![alt tag](https://raw.githubusercontent.com/Aldrog/approximation-task/master/result.bmp)  
Red - f(x)  
Green - approximation with degree 3 polynomial  
Blue - approximation with Legendre polynomials

#Requirements
For compiling this you will need the following:
* Nim compiler version 0.12 or higher
* linalg module from git HEAD
```
nimble install linalg@#HEAD
```
* graphics and sdl1 modules for graph plotter
```
nimble install graphics sdl1
```
* SDL development headers
