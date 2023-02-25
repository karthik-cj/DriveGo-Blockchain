// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract UserDetails {
    mapping(address => User) private users;
    struct User {
        string name;
        string phoneNumber;
        string aadhar;
    }

    function setUserInformation(
        string memory _name,
        string memory _phoneNumber,
        string memory _aadhar
    ) public {
        require(msg.sender.balance >= 0.5 ether, "Insufficient balance");
        users[msg.sender].name = _name;
        users[msg.sender].phoneNumber = _phoneNumber;
        users[msg.sender].aadhar = _aadhar;
    }

    function retrieveUserInformation()
        public
        view
        returns (string memory, string memory, string memory)
    {
        User memory user = users[msg.sender];
        return (user.name, user.phoneNumber, user.aadhar);
    }

    mapping(address => Driver) private drivers;
    struct Driver {
        string name;
        string phoneNumber;
        string location;
        string model;
        string vehicleNumber;
        string rcBook;
        string license;
        string vehicleName;
        string aadhar;
    }

    address[] private driverArray;

    function setDriverInformation(
        string memory _name,
        string memory _phoneNumber,
        string memory _model,
        string memory _vehicleNumber,
        string memory _rcBook,
        string memory _license,
        string memory _vehicleName,
        string memory _aadhar
    ) public {
        require(msg.sender.balance >= 0.5 ether, "Insufficient balance");
        drivers[msg.sender].name = _name;
        drivers[msg.sender].phoneNumber = _phoneNumber;
        drivers[msg.sender].model = _model;
        drivers[msg.sender].vehicleNumber = _vehicleNumber;
        drivers[msg.sender].rcBook = _rcBook;
        drivers[msg.sender].license = _license;
        drivers[msg.sender].vehicleName = _vehicleName;
        drivers[msg.sender].aadhar = _aadhar;
    }

    function retrieveDriverInformation()
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        Driver memory driver = drivers[msg.sender];
        return (
            driver.name,
            driver.phoneNumber,
            driver.location,
            driver.model,
            driver.vehicleNumber,
            driver.rcBook,
            driver.license,
            driver.vehicleName,
            driver.aadhar
        );
    }

    function retrieveSpecificDriver(
        address driverAddress
    )
        public
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        Driver memory driver = drivers[driverAddress];
        return (
            driver.name,
            driver.phoneNumber,
            driver.location,
            driver.model,
            driver.vehicleNumber,
            driver.rcBook,
            driver.license,
            driver.vehicleName,
            driver.aadhar
        );
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
        returns (address[] memory, string[] memory, string[] memory)
    {
        string[] memory locations = new string[](driverArray.length);
        string[] memory models = new string[](driverArray.length);
        for (uint i = 0; i < driverArray.length; i++) {
            address driverAddress = driverArray[i];
            locations[i] = drivers[driverAddress].location;
            models[i] = drivers[driverAddress].model;
        }
        return (driverArray, locations, models);
    }
}
