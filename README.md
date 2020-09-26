
# tpp tool


## Installing
Using `tpp` tool is easy. First, clone the repository in your workspace
```bash
cd $HOME
git clone https://github.com/Kleiber/tools.git
```
Next, include the following line in your `~/.bashrc` file
```bash
export PATH=$PATH:$HOME/tools:
```
## Commands


```bash
tpp init <filename>
```

```bash
tpp build <filename>
```

```bash
tpp run <filename>
```

## Template


```go
// remove this code before your submission
#include "debug.h"
```


```go
// do not remove this code if you use cin or cout
ios::sync_with_stdio(false);
cin.tie(0);
```

## Debug

`tpp` tool also includes an easier way to show the content of our variables. It is very simple, we just have to use the `debug` function and send the variable that we want to show as a parameter. This is very useful when debugging our code. An example:

```go
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
debug:14 myVariable: tpp tool
debug:19 myMatrix:
[0 0 0 0 0]
[0 0 0 0 0]
[0 0 0 0 0]
[0 0 0 0 0]
[0 0 0 0 0]
debug:26 myVector:
[0 1 2 3 4 5 6 7 8 9]
```
