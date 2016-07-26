/*!
 * \file JamomaDevice.h
 *
 * \brief
 *
 * \details
 *
 * \author Théo de la Hogue
 *
 * \copyright This code is licensed under the terms of the "CeCILL-C"
 * http://www.cecill.info
 */

#pragma once

#include "Device.hpp"
#include "BasicNode.h"

namespace impl
{

class BasicDevice final :
        public OSSIA::v2::Device,
        public BasicNode
{
    private:
    public:
        BasicDevice() = delete;
        BasicDevice(const BasicDevice&) = delete;
        BasicDevice(BasicDevice&&) = delete;
        BasicDevice& operator=(const BasicDevice&) = delete;
        BasicDevice& operator=(BasicDevice&&) = delete;

        BasicDevice(std::unique_ptr<OSSIA::v2::Protocol> protocol,
                    std::string name);

        ~BasicDevice();
};
}
