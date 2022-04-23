#include <iostream>
using namespace std;

int f(const char* s){
  return 1;
}

int main(){

  auto 
    s1 = R"(asda)  ()(((((((\n(sdasdasd)", 
    s2 = "asdas\ndasd",
    s3 = R"__strange(")()~ˇ^˘˘°ß  "
    asdasdasd <   >>>>    `` ´\\\\ \t \b.,  )__strange" ;

  auto i = f(R"(asda)  ()(((((((\n(sdasdasd)");
  

  cout << s1 << "\n";
  cout << s2 << "\n";
  cout << s3 << "\n";
  
  return 0;
}
