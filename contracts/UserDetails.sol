// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract UserDetails {
    mapping(address => User) private users;
    struct User {
        string name;
        uint phoneNumber;
    }

    function setUserInformation(string memory _name, uint _phoneNumber) public {
        require(msg.sender.balance >= 0.5 ether, "Insufficient balance");
        users[msg.sender].name = _name;
        users[msg.sender].phoneNumber = _phoneNumber;
    }

    function retrieveUserInformation()
        public
        view
        returns (string memory, uint)
    {
        User memory user = users[msg.sender];
        return (user.name, user.phoneNumber);
    }

    mapping(address => Driver) private drivers;
    struct Driver {
        string name;
        uint phoneNumber;
        string location;
    }

    address[] private driverArray;

    function setDriverInformation(
        string memory _name,
        uint _phoneNumber
    ) public {
        require(msg.sender.balance >= 0.5 ether, "Insufficient balance");
        drivers[msg.sender].name = _name;
        drivers[msg.sender].phoneNumber = _phoneNumber;
    }

    function retrieveDriverInformation()
        public
        view
        returns (string memory, uint, string memory)
    {
        Driver memory driver = drivers[msg.sender];
        return (driver.name, driver.phoneNumber, driver.location);
    }

    function retrieveSpecificDriver(
        address driverAddress
    ) public view returns (string memory, uint) {
        Driver memory driver = drivers[driverAddress];
        return (driver.name, driver.phoneNumber);
    }

    function setDriverLocation(string memory _location) public {
        drivers[msg.sender].location = _location;
        bool isDriverInArray = false;
        for (uint i = 0; i < driverArray.length; i++) {
            if (driverArray[i] == msg.sender) {
                isDriverInArray = true;
                break;
            }
        }
        if (!isDriverInArray) {
            driverArray.push(msg.sender);
        }
    }

    function deleteDriverLocation() public {
        if (bytes(drivers[msg.sender].location).length > 0) {
            drivers[msg.sender].location = "";
        }
        for (uint i = 0; i < driverArray.length; i++) {
            if (driverArray[i] == msg.sender) {
                driverArray[i] = driverArray[driverArray.length - 1];
                driverArray.pop();
                break;
            }
        }
    }

    function getAllDriverDetails()
        public
        view
        returns (address[] memory, string[] memory)
    {
        string[] memory locations = new string[](driverArray.length);
        for (uint i = 0; i < driverArray.length; i++) {
            address driverAddress = driverArray[i];
            locations[i] = drivers[driverAddress].location;
        }
        return (driverArray, locations);
    }
}
