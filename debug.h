// author: KleiberXD

#include <iostream>
#include <queue>
#include <stack>
#include <vector>
#include <regex>

using namespace std;

#define debug(...) cerr<<"debug:"<<__LINE__<<" "<<#__VA_ARGS__<<": "<<to_string(__VA_ARGS__)<<endl
#define debugm(...) cerr<<"debug:"<<__LINE__<<" ", debug_out_multiple(#__VA_ARGS__, __VA_ARGS__)

#define print(...) fprintf(stderr, __VA_ARGS__), fflush(stderr)
#define debugt(f) \
    for ( \
        auto blockTime = make_pair(chrono::high_resolution_clock::now(), true); \
        blockTime.second; \
        print("debug:%d Time execution %s(): %lld ms\n", __LINE__, f, chrono::duration_cast<chrono::milliseconds>(chrono::high_resolution_clock::now() - blockTime.first).count()), blockTime.second = false \
    )

string to_string(bool b) {
    return (b?"1":"0");
}

string to_string(char c){
    return "'" + string({c}) + "'";
}

string to_string(string s) {
    return '"' + s + '"';
}

string to_string(const char* s) {
  return to_string((string) s);
}

template <typename A, typename B>
string to_string(pair<A, B> p) {
  return "(" + to_string(p.first) + "," + to_string(p.second) + ")";
}

template <typename A, typename B, typename C>
string to_string(tuple<A, B, C> p) {
  return "(" + to_string(get<0>(p)) + ", " + to_string(get<1>(p)) + ", " + to_string(get<2>(p)) + ")";
}

template <typename A, typename B, typename C, typename D>
string to_string(tuple<A, B, C, D> p) {
  return "(" + to_string(get<0>(p)) + ", " + to_string(get<1>(p)) + ", " + to_string(get<2>(p)) + ", " + to_string(get<3>(p)) + ")";
}

template <typename A>
string to_string(vector<A> a) {
  string output = "\n[";
    for (int i = 0; i < a.size(); i++) {
        if(i > 0) output += " ";
        output += to_string(a[i]);
    }
    output += "]";
    return output;
}

template <typename A>
string to_string(queue<A>& a) {
  typedef typename std::queue<A>::container_type Container;
  const auto containerPtr = reinterpret_cast<const Container*>(&a);

  vector<A> tmp;
  for(auto v : *containerPtr) tmp.push_back(v);

  return to_string(tmp);
}

template <typename A>
string to_string(stack<A>& a) {
  typedef typename std::stack<A>::container_type Container;
  const auto containerPtr = reinterpret_cast<const Container*>(&a);

  vector<A> tmp;
  for(auto v : *containerPtr) tmp.push_back(v);
  reverse(tmp.begin(), tmp.end());

  return to_string(tmp);
}

template <typename A, size_t R>
string to_string(A (&a)[R]){
    string output = "\n[";
    for (int i = 0; i < R; i++) {
        if(i > 0) output += " ";
        output += to_string(a[i]);
    }
    output += "]";
    return output;
}

template <typename A, size_t R, size_t C>
string to_string(A (&a)[R][C]) {
    string output = "";
    for (int i = 0; i < R; i++) {
        output += to_string(a[i]);
    }
    output += "";
    return output;
}

template <typename A>
string to_string(A a) {
  string output = "[";
  bool first = true;
  for (const auto &v : a) {
    if(!first) output += " ";
    output += to_string(v);
    first = false;
  }
  output += "]";
  return output;
}

void debug_out_multiple(string names) { cerr << endl; }

template <typename Head, typename... Tail>
void debug_out_multiple(string names, Head H, Tail... T) {
  auto pos = names.find(',');
  auto name = names.substr(0, pos);
  names = names.substr(pos + 1);
  while(names.front() == ' '){
    names = names.substr(1);
  }

  auto output = to_string(H);

  regex remove_newlines("\n+");
  output = regex_replace(output, remove_newlines, "");

  cerr<<name<<": "<<output<<"  ";
  debug_out_multiple(names, T...);
}
