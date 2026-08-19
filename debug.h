// author: KleiberXD

#pragma once

#include <iostream>
#include <queue>
#include <stack>
#include <vector>
#include <tuple>
#include <string>
#include <algorithm>

using namespace std;

// Forward declarations for template resolution
string to_string(bool b);
string to_string(vector<bool>::reference b);
string to_string(char c);
string to_string(string s);
string to_string(const char* s);
template <typename A, typename B> string to_string(pair<A, B> p);
template <typename... A> string to_string(tuple<A...> t);
template <typename A> string to_string(vector<A> a);
template <typename A> string to_string(queue<A> a);
template <typename A> string to_string(stack<A> a);
template <typename A> string to_string(priority_queue<A> a);
template <typename A, size_t R> string to_string(A (&a)[R]);
template <typename A, size_t R, size_t C> string to_string(A (&a)[R][C]);
template <typename A> string to_string(A a);

#define debug(...) cerr<<"debug:"<<__LINE__<<" "<<#__VA_ARGS__<<": "<<to_string(__VA_ARGS__)<<endl
#define debugm(...) cerr<<"debug:"<<__LINE__<<" ", debug_out_multiple(#__VA_ARGS__, __VA_ARGS__)

#define print(...) fprintf(stderr, __VA_ARGS__), fflush(stderr)
#define debugt(f) \
    for ( \
        auto blockTime = make_pair(chrono::high_resolution_clock::now(), true); \
        blockTime.second; \
        print("debug:%d Time execution %s(): %lld ms\n", __LINE__, f, chrono::duration_cast<chrono::milliseconds>(chrono::high_resolution_clock::now() - blockTime.first).count()), blockTime.second = false \
    )

inline string to_string(bool b) {
    return (b?"1":"0");
}

inline string to_string(vector<bool>::reference b) {
    return to_string((bool)b);
}

inline string to_string(char c){
    return "'" + string({c}) + "'";
}

inline string to_string(string s) {
    return '"' + s + '"';
}

inline string to_string(const char* s) {
  return to_string((string) s);
}

template <typename A, typename B>
string to_string(pair<A, B> p) {
  return "(" + to_string(p.first) + "," + to_string(p.second) + ")";
}

template <typename Tuple, size_t... I>
string tuple_to_string(const Tuple& t, index_sequence<I...>) {
  string output = "(";
  bool first = true;
  (void)initializer_list<int>{
    (output += (first ? "" : ",") + to_string(get<I>(t)), first = false, 0)...
  };
  return output + ")";
}

template <typename... A>
string to_string(tuple<A...> t) {
  return tuple_to_string(t, index_sequence_for<A...>{});
}

template <typename A>
string to_string(vector<A> a) {
  string output = "\n[";
    for (int i = 0; i < (int)a.size(); i++) {
        if(i > 0) output += " ";
        output += to_string(a[i]);
    }
    output += "]";
    return output;
}

template <typename A>
string to_string(queue<A> a) {
  vector<A> tmp;
  while (!a.empty()) {
    tmp.push_back(a.front());
    a.pop();
  }
  return to_string(tmp);
}

template <typename A>
string to_string(stack<A> a) {
  vector<A> tmp;
  while (!a.empty()) {
    tmp.push_back(a.top());
    a.pop();
  }
  return to_string(tmp);
}

template <typename A>
string to_string(priority_queue<A> a) {
  vector<A> tmp;
  while (!a.empty()) {
    tmp.push_back(a.top());
    a.pop();
  }
  return to_string(tmp);
}

template <typename A, size_t R>
string to_string(A (&a)[R]){
    string output = "\n[";
    for (int i = 0; i < (int)R; i++) {
        if(i > 0) output += " ";
        output += to_string(a[i]);
    }
    output += "]";
    return output;
}

template <typename A, size_t R, size_t C>
string to_string(A (&a)[R][C]) {
    string output = "";
    for (int i = 0; i < (int)R; i++) {
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

static inline string remove_newlines(const string& s) {
  string result;
  result.reserve(s.size());
  for (char c : s) {
    if (c != '\n') result += c;
  }
  return result;
}

inline void debug_out_multiple(string names) { cerr << endl; }

template <typename Head, typename... Tail>
void debug_out_multiple(string names, Head H, Tail... T) {
  auto pos = names.find(',');
  auto name = names.substr(0, pos);
  names = (pos == string::npos) ? "" : names.substr(pos + 1);
  while (!names.empty() && names.front() == ' ') {
    names = names.substr(1);
  }

  auto output = to_string(H);
  output = remove_newlines(output);

  cerr<<name<<": "<<output<<"  ";
  debug_out_multiple(names, T...);
}
