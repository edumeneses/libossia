#include "Network/Node.h"
#include "Address.cpp"
#include "../Misc/Container.cpp"

#include "TTModular.h"

using namespace OSSIA;
using namespace std;

class JamomaNode : public virtual Node, public JamomaContainer<Node>
{
  
private:
  
  // Implementation specific
  TTNodeDirectory *     mDirectory;
  TTNode *              mNode;
  JamomaNode *          mParent;
  shared_ptr<Address>   mAddress;
  
public:

  // Constructor, destructor
  JamomaNode(string name, TTNodeDirectory * aDirectory = nullptr, TTNode * aNode = nullptr) :
  mDirectory(aDirectory),
  mNode(aNode)
  {
    if (mNode)
    {
      // edit parent
      TTNode *parent = mNode->getParent();
      if (parent)
      {
        TTString parentNameInstance = parent->getName().c_str();
        if (parent->getInstance() != kTTSymEmpty)
        {
          parentNameInstance += parent->getInstance().c_str();
        }
        
        mParent = new JamomaNode(parentNameInstance.data(), mDirectory, parent);
      }
      
      // edit address only for Data object
      TTObject object = mNode->getObject();
      if (object.valid())
      {
        TTSymbol objectName = object.name();
        
        if (objectName == kTTSym_Mirror)
          objectName = TTMirrorPtr(object.instance())->getName();
        
        if (objectName == "Data")
        {
          mAddress = shared_ptr<Address>(new JamomaAddress(object));
        }
      }
    }
  }
  
  ~JamomaNode()
  {
    ;
  }

  // Navigation
  virtual Node & getParent() const override
  {
    return *mParent;
  }

  // Accessors
  virtual string getName() const override
  {
    if (mNode)
      return mNode->getName().c_str();
    
    return "";
  }
  
  virtual const shared_ptr<Address> & getAddress() const override
  {
    return mAddress;
  }
  
  virtual bool removeAddress() override
  {
    if (mNode)
    {
      return !mNode->setObject();
    }
    
    return false;
  }

  // Address Factory
  virtual shared_ptr<Address> createAddress(AddressValue::Type type) override
  {
    if (mNode)
    {
      TTSymbol applicationType = getApplicationType();
      TTObject object;
      
      // for local application case
      if (applicationType == kTTSym_local)
      {
        object = TTObject("Data", "parameter");
        mNode->setObject(object);
      }
      
      // for proxy application
      else if (applicationType == kTTSym_proxy)
      {
        TTAddress nodeAddress;
        mNode->getAddress(nodeAddress);
        TTValue args(nodeAddress, "parameter");
        object = getApplication().send("ProxyDataInstantiate", args);
      }
      
      // for mirror application
      else if (applicationType == kTTSym_mirror)
      {
        ; // todo : allow to use TTApplication::appendMirrorObject method
      }
      
      if (object.valid())
      {
        if (type == AddressValue::Type::NONE)
          object.set("type", kTTSym_none);
        else if (type == AddressValue::Type::BOOL)
          object.set("type", kTTSym_boolean);
        else if (type == AddressValue::Type::INT)
          object.set("type", kTTSym_integer);
        else if (type == AddressValue::Type::FLOAT)
          object.set("type", kTTSym_decimal);
        else if (type == AddressValue::Type::CHAR)
          object.set("type", kTTSym_string);
        else if (type == AddressValue::Type::STRING)
          object.set("type", kTTSym_string);
        else if (type == AddressValue::Type::TUPLE)
          object.set("type", kTTSym_array);
        else if (type == AddressValue::Type::GENERIC)
          object.set("type", kTTSym_generic);
      }
    }
    
    // todo : clear former address
    
    return getAddress();
  }

  // Child Node Factory
  virtual iterator emplace(const_iterator pos, string name) override
  {
    return iterator();
  }

private:
  
  TTObject & getApplication()
  {
    return mDirectory->getRoot()->getObject();
  }
  
  TTSymbol getApplicationType()
  {
    TTSymbol type;
    mDirectory->getRoot()->getObject().get("type", type);
    
    return type;
  }
};
