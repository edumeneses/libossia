#include "Editor/TimeProcessList.h"
#include "../Misc/Container.cpp"

using namespace OSSIA;
using namespace std;

class MockTimeProcessList :
    public TimeProcessList, public MockContainer<TimeProcess> {

public:

  // Constructor, destructor
  MockTimeProcessList(){}
  virtual ~MockTimeProcessList() {}

};
