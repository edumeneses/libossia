/*!
 * \file Address.h
 *
 * \defgroup Network
 *
 * \brief
 *
 * \details
 *
 * \author Clément Bossut
 * \author Théo de la Hogue
 *
 * \copyright This code is licensed under the terms of the "CeCILL-C"
 * http://www.cecill.info
 */

#pragma once

#include <string>
#include <functional>
#include <memory>
#include "Editor/Domain.h"
#include "Editor/Expression.h"
#include "Network/AddressProperties.h"
#include <ossia_export.h>

namespace OSSIA
{

class Node;
class SafeValue;
/*! to get the value back
 \param the returned value */
using ValueCallback = std::function<void(const SafeValue&)>;

class OSSIA_EXPORT Address : public CallbackContainer<ValueCallback>
{

public:

#if 0
# pragma mark -
# pragma mark Definitions
#endif

  using iterator = typename CallbackContainer<ValueCallback>::iterator;

#if 0
# pragma mark -
# pragma mark Life cycle
#endif

  /*! destructor */
  virtual ~Address();

#if 0
# pragma mark -
# pragma mark Network
#endif

  /*! get the node where the address is
   \return std::shared_ptr<#Node> the node where the address is */
  virtual const std::shared_ptr<Node> getNode() const = 0;

  /*! pull the address value from a device using its protocol
   \see Protocol::pullAddressValue method
  */
  virtual void pullValue() = 0;

  /*! set then push the address value to a device using its protocol
   \see Protocol::pushAddressValue method
   \param const #Value* the value (push the current value if no argument)
   \return #Address the address */
  virtual Address & pushValue(const SafeValue&) = 0;

  /*! set then push the address value to a device using its protocol
   \see Protocol::pushAddressValue method
   \param const #Value* the value (push the current value if no argument)
   \return #Address the address */
  virtual Address & pushValue() = 0;

#if 0
# pragma mark -
# pragma mark Accessors
#endif

  /*! clone the address value
   \details thread-safe
   \param std::initializer_list<char> optionnal index list to clone only some elements from a Tuple value
   \return const #Value a cloned value.  */
  virtual SafeValue cloneValue(std::vector<char> = {}) const = 0;

  /*! set the address value
   \note call pushValue if you need to sync the value with the device
   \param const #Value* the value
   \note it is possible to set the value using a #Type::Destination to query the value from another address
   \return #Address the address */
  virtual Address & setValue(const SafeValue&) = 0;

  /*! get the address type
   \return #Type of the address */
  virtual Type getValueType() const = 0;

  /*! set the address type
   \param #Type of the address
   \return #Address the address */
  virtual Address & setValueType(Type) = 0;

  /*! get the address access mode
   \return #AccessMode of the address */
  virtual AccessMode getAccessMode() const = 0;

  /*! set the address access mode
   \param #AccessMode of the address
   \return #Address the address */
  virtual Address & setAccessMode(AccessMode) = 0;

  /*! get the address domain
   \return #Domain of the address */
  virtual const std::shared_ptr<Domain> & getDomain() const = 0;

  /*! set the address domain
   \param #Domain of the address
   \return #Address the address */
  virtual Address & setDomain(std::shared_ptr<Domain>) = 0;

  /*! get the address bounding mode
   \todo multiple ?
   \return #BoundingMode of the address */
  virtual BoundingMode getBoundingMode() const = 0;

  /*! set the address bounding mode
   \todo multiple ?
   \param #BoundingMode of the address
   \return #Address the address */
  virtual Address & setBoundingMode(BoundingMode) = 0;

  /*! get the address repetition filter status
   \return bool true is repetition filter is enabled */
  virtual bool getRepetitionFilter() const = 0;

  /*! set the address repetition filter status
   \param bool true is to enable repetition filter
   \return #Address the address */
  virtual Address & setRepetitionFilter(bool = true) = 0;
};
}

