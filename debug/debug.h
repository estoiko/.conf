/*
last time edited 28.08.2024
*/

#include <iostream>
#include <numeric>
#include <utility>
#include <string>

using namespace std;

// MY TEMPLATES
template <typename T>
T Max(T a) {
    return a;
}

template <typename T, typename... Package>
T Max(T x, Package... p) {
    return max(x, Max(p...));
}

template <typename T>
T Min(T a) {
    return a;
}

template <typename T, typename... Package>
T Min(T x, Package... p) {
    return max(x, Min(p...));
}

// ex. TOURIST DEBUG + MIREA
template <typename A, typename B>
string to_string(pair<A, B> p);

string to_string(const string& s) {
    return '"' + s + '"';
}

string to_string(const char* s) {
    return to_string((string) s);
}

string to_string(char s) {
    return to_string((string() + s));
}

string to_string(bool b) {
    return (b ? "true" : "false");
}

string to_string(vector<bool> v) {
    bool first = true;
    string res = "{";
    for (int i = 0; i < static_cast<int>(v.size()); i++) {
        if (!first) {
            res += ", ";
        }
        first = false;
        res += to_string(v[i]);
    }
    res += "}";
    return res;
}

template <size_t N>
string to_string(bitset<N> v) {
    return []<size_t... I>(index_sequence<I...>, auto v){
        return (string("") + ... + "01"[v[I]]);
    }(make_index_sequence<N>{}, v);
}

// SFINAE
template <typename A>
string to_string(A v) {
    return empty(v) ? "{}" : accumulate(++cbegin(v), cend(v), "{" + to_string(*cbegin(v)),
        [](auto l, auto r){ return l + ", " + to_string(r); }) + "}";
}

template <typename A, typename B>
string to_string(pair<A, B> p) {
    return "(" + to_string(p.first) + ", " + to_string(p.second) + ")";
}

// C++ 20
template <typename ...Args>
string to_string(tuple<Args...> p) {
    return []<size_t... N>(auto p, index_sequence<N...>) {
        return string("(") + ( ((N ? ", " : "") + to_string(get<N>(p)) ) + ...) + ")";
    }(p, make_index_sequence<sizeof...(Args)>{});
}

template <typename ... Args>
void debug_out(Args... args) {
    (cerr << ... << (to_string(args) + " ") ) << endl;
}
