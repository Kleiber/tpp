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

### Mac
For Mac, clone the repository in your workspace and include the following line in your `.zshrc` file (use the command `vim ~/.zshrc` to edit)

```bash
export PATH=$PATH:$HOME/tpp:
```

Finally, restart your terminal

### Windows
For Windows, you need to have [Git for Windows](https://gitforwindows.org/) installed and perform the same steps as in linux.

The minimum requirement to use `tpp` tool is the **C++11** standard library

## Setup

include the following line in your `.bashrc` or `.zshrc`

```bash
export TPP_WORKSPACE=<local-workspace-path>
export TPP_REPO=<github-path-repository>
export TPP_GITHUB=<github-url-repository>
export TPP_BRANCH=<github-branch-name>
export TPP_IDE=<ide-to-edit-files>
```

Where:

- _TPP_WORKSPACE_: Local directory path where solutions will be created.
- _TPP_REPO_: Local directory path where the Github repository will be cloned.
- _TPP_GITHUB_: Github repository url where the solutions will be uploaded.
- _TPP_BRANCH_: Github repository branch.
- _TPP_IDE_: IDE command that will be used to edit the solutions.

## Commands

### ***init***

Initializes a new solution with the name passed as a parameter. Basically a new directory is created with four files: the cpp template `<solution-name>.cpp`, the input file `in.tpp`, the expected output file `expected.tpp` and the output file `out.tpp`

```bash
tpp init <solution-name>
```

### ***build***

Compiles the generated cpp template within the solution. Basically it is the translation of executing command `g ++ -o build <solution-name>.cpp`

```bash
tpp build
```

### ***run***

Compiles and executes the generated cpp template within the solution. If the `in.tpp` file has test cases, they will be used in the execution using standard input (`build < in.tpp`). Otherwise, it will be necessary to manually enter the test cases as usual

```bash
tpp run
```

### ***test***

Compiles, executes and test the generated cpp template within the solution. For the execution of this command it is necessary to have the `in.tpp` file with the input cases and the `expected.tpp` file with the expected outputs. From the cpp template an `out.tpp` file will be generated to be compared (`build < in.tpp > out.tpp`). Basically it is the translation of executing command `diff expected.tpp out.tpp`

```bash
tpp test
```

### ***prepare***

Prepares and test a new file to submit without the debug reference and its uses within the generated template

```bash
tpp prepare
```

### ***list***

List all the solutions created that are in the workspace. some columns are displayed in the output:

- _SOLUTION NAME:_ Name of the solution with which it was created.
- _JUDGE:_ Name of the assigned judge.
- _TAG:_ Name of the assigned tag.
- _TEST STATUS:_ Test status of the solution.
- _READY:_ Indicates if the solution was ready to submit.
- _LAST UPDATE:_ Last time the solution was updated.

```bash
tpp list
```

### ***submit***

Submit solution to github repository. The path where the solution will be placed in the repository will be the concatenation between the judge and tag assigned to the solution (To assign the judge and tag use the commands `tpp judge` and `tpp tag` respectively).

```bash
tpp submit
```

**Note:** `tpp` tool also provides other commands that can help you in developing your solution, to get more information about these other commands run _tpp --help_.

## Template

Since in competitive programming time is crucial, `tpp` tool allows you to generate a code base cpp template to start programming there.

At the top of the template you will see the following `include` statement:

```c++
// remove this reference to debug.h before your submission
#include "debug.h"
```

That line allows you to make use of the debug method. **Do not forget that before submitting your code you must remove that line or use the command prepare**.

The second and no less important thing that we can see in the template are the following two code lines:

```c++
// do not remove this code if you use cin or cout
ios::sync_with_stdio(false);
cin.tie(0);
```

In competitive programming is often recommended to use `scanf/printf` instead of `cin/cout` for a fast input and output. However, you can still **use `cin/cout` and achieve the same performace as `scanf/printf` by including those two code lines in our `main()` function.**

## Debug

The main task of `tpp` command line is to include the `debug.h` script, who allows you to debug your variables showing their content in a simple and practical way. Its use is quite straightforward, you just have to call the `debug` or `debugm` method and send the variable, that you want to show, as a parameter.

### Example

```c++
/**
*  Generated by tpp tool
*  File: hello.cpp
*  Created: 28-08-2021 14:17:55
**/

#include <bits/stdc++.h>
using namespace std;

// remove this reference to debug.h before your submission
#include "debug.h"

int main() {
    // do not remove this code if you use cin or cout
    ios::sync_with_stdio(false);
    cin.tie(0);

    string myVariable = "tpp tool";
    debug(myVariable);

    int myMatrix[8][8];
    memset(myMatrix, 0, sizeof(myMatrix));
    debug(myMatrix);
    debug(myMatrix[2][2]);

    int  myArray[4] = {0, 1, 2, 4};
    debug(myArray);
    debug(myArray[3]);

    vector<int> myVector;
    for(int i = 0; i < 8; i++) {
        myVector.push_back(i);
    }
    debug(myVector);
    debug(myVector[4]);

    vector<pair<int,int>> myPairs;
    for(int i = 0; i < 4; i++) {
        myPairs.push_back({i, 2*i});
    }
    debug(myPairs);
    debug(myPairs[2]);

    stack<char> myStack;
    myStack.push('(');
    myStack.push(')');
    debug(myStack);

    queue<pair<int,int>> myQueue;
    myQueue.push(make_pair(1,0));
    myQueue.push(make_pair(0,1));
    debug(myQueue);

    cerr<<"debug multiple variables. DO NOT USE to debug a multi-dimensional array"<<endl;
    debugm(myVariable ,myStack, myQueue, myPairs, myVector);

    string greeting;
    getline(cin, greeting);
    cout << greeting <<endl;

    return 0;
}
```

If we have the above code snippet and the following input file and expected ouput file contents:

```bash
Input:
Hello World!

Expected Output:
Hello World!
```

Executing the following `tpp` commands:

```bash
$ cat ~/.bashrc
export TPP_WORKSPACE=$HOME/code
export TPP_REPO=$HOME/repository
export TPP_GITHUB=https://github.com/user/repository.git
export TPP_BRANCH=master
export TPP_IDE=vim

// go to workspace
$ cd $TPP_WORKSPACE

$ tpp init hello
'hello' solution was initialized successfully!

// go to generated solution
$ cd hello

// open the generated template hello.cpp file in the solution and copy the code snippet
$ tpp open

// open the generated input file in.tpp and copy the content
$ tpp in

// open the generated expected file expected.tpp and copy the content
$ tpp exp

$ tpp ls
SOLUTION NAME              JUDGE          TAG           TEST STATUS    READY     LAST UPDATE
hello                                                   Pending        No        28-08-2021 18:45:45

$ tpp build
'hello' solution was compiled successfully!

$ tpp run
debug:31 myVariable: "tpp tool"
debug:35 myMatrix:
[0 0 0 0 0 0 0 0]
[0 0 0 0 0 0 0 0]
[0 0 0 0 0 0 0 0]
[0 0 0 0 0 0 0 0]
[0 0 0 0 0 0 0 0]
[0 0 0 0 0 0 0 0]
[0 0 0 0 0 0 0 0]
[0 0 0 0 0 0 0 0]
debug:36 myMatrix[2][2]: 0
debug:39 myArray:
[0 1 2 4]
debug:40 myArray[3]: 4
debug:46 myVector:
[0 1 2 3 4 5 6 7]
debug:47 myVector[4]: 4
debug:53 myPairs:
[(0,0) (1,2) (2,4) (3,6)]
debug:54 myPairs[2]: (2,4)
debug:59 myStack:
[')' '(']
debug:64 myQueue:
[(1,0) (0,1)]
debug multiple variables. DO NOT USE to debug a multi-dimensional array
debug:67 myVariable : "tpp tool"  myStack: [')' '(']  myQueue: [(1,0) (0,1)]  myPairs: [(0,0) (1,2) (2,4) (3,6)]  myVector: [0 1 2 3 4 5 6 7]  
Hello World!

$ tpp test
'hello.cpp' test PASSED!

$ tpp ls
SOLUTION NAME              JUDGE          TAG           TEST STATUS    READY     LAST UPDATE
hello                                                   Passed         No        28-08-2021 18:48:54

$ tpp prepare
'hello_ready.cpp' was generated successfully!
'hello_ready.cpp' test PASSED!

$ tpp ls
SOLUTION NAME              JUDGE          TAG           TEST STATUS    READY     LAST UPDATE
hello                                                   Passed         Yes       28-08-2021 18:49:12
```

Opening the generated file for submission `hello_ready.cpp`:

```c++
/**
*  Generated by tpp tool
*  File: hello.cpp
*  Created: 28-08-2021 14:17:55
**/

#include <bits/stdc++.h>
using namespace std;


int main() {
    // do not remove this code if you use cin or cout
    ios::sync_with_stdio(false);
    cin.tie(0);

    string myVariable = "tpp tool";

    int myMatrix[8][8];
    memset(myMatrix, 0, sizeof(myMatrix));

    int  myArray[4] = {0, 1, 2, 4};

    vector<int> myVector;
    for(int i = 0; i < 8; i++) {
        myVector.push_back(i);
    }

    vector<pair<int,int>> myPairs;
    for(int i = 0; i < 4; i++) {
        myPairs.push_back({i, 2*i});
    }

    stack<char> myStack;
    myStack.push('(');
    myStack.push(')');

    queue<pair<int,int>> myQueue;
    myQueue.push(make_pair(1,0));
    myQueue.push(make_pair(0,1));

    cerr<<"debug multiple variables. DO NOT USE to debug a multi-dimensional array"<<endl;

    string greeting;
    getline(cin, greeting);
    cout << greeting <<endl;

    return 0;
}
```

`tpp` also gives us the option to save our solutions in our Github repository as follows:

```bash
$ tpp judge Kattis

$ tpp tag AdHoc

$ tpp ls
SOLUTION NAME              JUDGE          TAG           TEST STATUS    READY     LAST UPDATE
hello                      Kattis         AdHoc         Passed         Yes       28-08-2021 18:51:12

$ tpp submit
Insert a commit message and press enter:
add hello solution using tpp tool
Pushing 'hello_ready.cpp' to 'Kattis/AdHoc' directory...
'hello' solution was upload to the github repo successfully!
```
