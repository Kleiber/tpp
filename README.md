
# tpp

## Overview

`tpp` is a command line that aims to help competitive programmers optimizing code compilation, testing, and debugging time.

## Installing
### Linux
Using `tpp` command line is simple. First, clone the repository in your workspace
```bash
cd $HOME
git clone https://github.com/Kleiber/tpp.git
```
Next, include the following line in your `.bashrc` file (use the command `vim ~/.bashrc` to edit)
```bash
export PATH=$PATH:$HOME/tpp:
```
Finally, restart your terminal or run the command `source ~/.bashrc`

### Windows
For Windows, you need to have [Git for Windows](https://gitforwindows.org/) installed and do the same setup.

## Commands
### ***init***
Initializes a new template with the `filename`. Basically a new `.cpp` file is created to start coding into it.
```bash
tpp init <filename>
```
### ***build***
Compiles the `filename` by generating a `build` binary. Basically it is the translation of executing command `g++ -o build filename`
```bash
tpp build <filename>
```
### ***run***
Compiles and executes the `filename`. If you have an `in.tpp` file with the test cases, They will be used in the execution using standard input (`build < in.tpp`). Otherwise, it will be necessary to manually enter the test cases as usual
```bash
tpp run <filename>
```
### ***test***
Compiles, executes and test the `filename`. For the execution of this command it is necessary to have the `in.tpp` file with the input cases and the `expected.tpp` file with the expected outputs. They will be used in the execution. Internally, the `out.tpp` file will be generated to compare with the defined expected output. Basically it is the translation of executing command `diff expected.tpp out.tpp`
```bash
tpp test <filename>
```

In all commands it is not necessary to put the extension `.cpp` in the `filename` parameter

## Template

Since in competitive programming time is crucial, `tpp` tool allows you to generate a code base template to start programming there.

At the top of the template you will see the following `include` statement:
```c++
// remove this code before your submission
#include "debug.h"
```
That line allows you to make use of the debug method. **Do not forget that before submitting your code you must remove that line**.

The second and no less important thing that we can see in the template are the following two code lines:
```c++
// do not remove this code if you use cin or cout
ios::sync_with_stdio(false);
cin.tie(0);
```
In competitive programming is often recommended to use `scanf/printf` instead of `cin/cout` for a fast input and output. However, you can still **use `cin/cout` and achieve the same performace as `scanf/printf` by including those two code lines in our `main()` function.**

## Debug

The main task of `tpp` command line is to include the `debug.h` script, who allows you to debug your variables showing their content in a simple and practical way. Its use is quite straightforward, you just have to call the `debug` method and send the variable, that you want to show, as a parameter.

An example:

```c++
#include <bits/stdc++.h>
using namespace std;

// remove this code before your submission
#include "debug.h"

int main() { 
    // do not remove this code if you use cin or cout
    ios::sync_with_stdio(false);
    cin.tie(0);

    string myVariable = "tpp tool";

    debug(myVariable);

    int myMatrix[5][5];
    memset(myMatrix, 0, sizeof(myMatrix));

    debug(myMatrix);

    vector<int> myVector;
    for(int i = 0; i < 10; i++) {
    	myVector.push_back(i);
    }

    debug(myVector);

    return 0;
}
```

Output:
```
debug:17 myVariable: "tpp tool"
debug:22 myMatrix:
[0 0 0 0 0]
[0 0 0 0 0]
[0 0 0 0 0]
[0 0 0 0 0]
[0 0 0 0 0]
debug:29 myVector:
[0 1 2 3 4 5 6 7 8 9]
```
