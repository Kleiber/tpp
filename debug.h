// author: KleiberXD

#define debug(...) cerr<<"debug:"<<__LINE__<<" "<<#__VA_ARGS__<<": "<<to_string(__VA_ARGS__)<<endl

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
