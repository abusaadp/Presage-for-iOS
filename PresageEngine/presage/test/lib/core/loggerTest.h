
/******************************************************
 *  Presage, an extensible predictive text entry system
 *  ---------------------------------------------------
 *
 *  Copyright (C) 2008  Matteo Vescovi <matteo.vescovi@yahoo.co.uk>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program; if not, write to the Free Software Foundation, Inc.,
    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
                                                                             *
                                                                **********(*)*/


#ifndef PRESAGE_LOGGERTEST
#define PRESAGE_LOGGERTEST

#include <cppunit/extensions/HelperMacros.h>

#include "core/logger.h"

class LoggerTest : public CppUnit::TestFixture { 
public:
    void setUp();
    void tearDown();

    void testStandardErrorOutput();
    void testFileOutput();

    void testSetLevelManipulator();
    void testCurrentLevelManipulator();

private:

    CPPUNIT_TEST_SUITE( LoggerTest );
    CPPUNIT_TEST( testStandardErrorOutput );
    CPPUNIT_TEST( testFileOutput          );
    CPPUNIT_TEST( testSetLevelManipulator );
    CPPUNIT_TEST( testCurrentLevelManipulator );
    CPPUNIT_TEST_SUITE_END();
};

#endif // PRESAGE_LOGGERTEST
