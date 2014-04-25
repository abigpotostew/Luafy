//
//  StringBuilder.h
//  Luafy
//
//  Created by Stewart Bracken on 3/13/14.
//
//

#ifndef Luafy_StringBuilder_h
#define Luafy_StringBuilder_h

//From http://stackoverflow.com/a/2463103

class StringBuilder {
private:
   std::string main;
   std::string scratch;
   
   const std::string::size_type ScratchSize = 1024;  // or some other arbitrary number
   
public:
   StringBuilder & append(const std::string & str) {
      scratch.append(str);
      if (scratch.size() > ScratchSize) {
         main.append(scratch);
         scratch.resize(0);
      }
      return *this;
   }
   
   const std::string & str() {
      if (scratch.size() > 0) {
         main.append(scratch);
         scratch.resize(0);
      }
      return main;
   }
};


#endif
