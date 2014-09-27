"""
Each file that starts with test... in this directory is scanned for subclasses of unittest.TestCase or testLib.RestTestCase
"""

import unittest
import os
import testLib


class TestUnit(testLib.RestTestCase):
    """Issue a REST API request to run the unit tests, and analyze the result"""
    def testUnit(self):
        respData = self.makeRequest("/TESTAPI/unitTests", method="POST")
        self.assertTrue('output' in respData)
        #print ("Unit tests output:\n"+
        #       "\n***** ".join(respData['output'].split("\n")))
        self.assertTrue('totalTests' in respData)
        print "***** Reported "+str(respData['totalTests'])+" unit tests. nrFailed="+str(respData['nrFailed'])
        # When we test the actual project, we require at least 10 unit tests
        minimumTests = 10
        self.assertTrue(respData['totalTests'] >= minimumTests,
                        "at least "+str(minimumTests)+" unit tests. Found only "+str(respData['totalTests'])+". use SAMPLE_APP=1 if this is the sample app")
        self.assertEquals(0, respData['nrFailed'])
       
        
class TestAddUser(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAdd1(self):
        respData = self.makeRequest("/users/add", method="POST", data = { 'username' : 'user3', 'password' : 'password'} )
        self.assertResponse(respData, count = 1)

    
class TestLoginUser(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.SUCCESS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testLogin(self):
        self.makeRequest("/users/add", method="POST", data = { 'username' : 'user2', 'password' : 'pass2'} )
        respData = self.makeRequest("/users/login", method="POST", data = { 'username' : 'user2', 'password' : 'pass2'} )
        self.assertResponse(respData, count = 2)


class TestLoginWithWrongPass(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.ERR_BAD_CREDENTIALS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testLoginWithWrongPass(self):
        #add user
        self.makeRequest("/users/add", method="POST", data = { 'username' : 'user2', 'password' : 'pass2'} )
        #attempt to login with just added user, but with a wrong password
        respData = self.makeRequest("/users/login", method="POST", data = { 'username' : 'user2', 'password' : 'wrong'} )
        self.assertResponse(respData, count = None)


class TestAddTwoUsersWithSameUsername(testLib.RestTestCase):
    """Test adding two users, should fail because duplicate username"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.ERR_USER_EXISTS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAddTwoUsersWithSameUsername(self):
        self.makeRequest("/users/add", method="POST", data = { 'username' : 'user2', 'password' : 'pass2'} )
        respData = self.makeRequest("/users/add", method="POST", data = { 'username' : 'user2', 'password' : ''} )
        self.assertResponse(respData, count = None)
 

class TestAddWithBlankUsername(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.ERR_BAD_USERNAME):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAddWithBlankUsername(self):
        #add user with blank username
        respData = self.makeRequest("/users/add", method="POST", data = { 'username' : '', 'password' : ''} )
        self.assertResponse(respData, count = None)


class TestAddUsernameTooLong(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.ERR_BAD_CREDENTIALS):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAddUsernameTooLong(self):
        #attempt to signup with a long username
        tempName = "I say we shall always have native crime to fear until the native people of this country have worthy purposes to inspire them and worthy goals to work for. For it is only because they see neither purpose nor goal that they turn to drink and crime and prostitution. Which do we prefer, a law-abiding, industrious and purposeful native people, or a lawless, idle and purposeless people?"
        respData = self.makeRequest("/users/login", method="POST", data = { 'username' : tempName, 'password' : 'wrong'} )
        self.assertResponse(respData, count = None)

class TestAddPasswordTooLong(testLib.RestTestCase):
    """Test adding users"""
    def assertResponse(self, respData, count = 1, errCode = testLib.RestTestCase.ERR_BAD_PASSWORD):
        """
        Check that the response data dictionary matches the expected values
        """
        expected = { 'errCode' : errCode }
        if count is not None:
            expected['count']  = count
        self.assertDictEqual(expected, respData)

    def testAddPasswordTooLong(self):
        #attempt to signup with a long username
        tempPass = "I say we shall always have native crime to fear until the native people of this country have worthy purposes to inspire them and worthy goals to work for. For it is only because they see neither purpose nor goal that they turn to drink and crime and prostitution. Which do we prefer, a law-abiding, industrious and purposeful native people, or a lawless, idle and purposeless people?"
        respData = self.makeRequest("/users/add", method="POST", data = { 'username' : "name", 'password' : tempPass} )
        self.assertResponse(respData, count = None)


