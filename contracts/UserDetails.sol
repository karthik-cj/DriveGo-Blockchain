// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract UserDetails {
    mapping(address => User) private users;
    struct User {
        string name;
        string phoneNumber;
        string aadhar;
        uint256 rating;
    }

    function setUserInformation(
        string memory _name,
        string memory _phoneNumber,
        string memory _aadhar
    ) public {
        users[msg.sender].name = _name;
        users[msg.sender].phoneNumber = _phoneNumber;
        users[msg.sender].aadhar = _aadhar;
        users[msg.sender].rating = 5;
    }

    function retrieveUserInformation()
        public
        view
        returns (string memory, string memory, string memory, uint256)
    {
        User memory user = users[msg.sender];
        return (user.name, user.phoneNumber, user.aadhar, user.rating);
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
        uint256 rating;
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
        drivers[msg.sender].name = _name;
        drivers[msg.sender].phoneNumber = _phoneNumber;
        drivers[msg.sender].model = _model;
        drivers[msg.sender].vehicleNumber = _vehicleNumber;
        drivers[msg.sender].rcBook = _rcBook;
        drivers[msg.sender].license = _license;
        drivers[msg.sender].vehicleName = _vehicleName;
        drivers[msg.sender].aadhar = _aadhar;
        drivers[msg.sender].rating = 5;
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
            string memory,
            uint256
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
            driver.aadhar,
            driver.rating
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
            string memory,
            uint256
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
            driver.aadhar,
            driver.rating
        );
    }

    function setDriverLocation(string memory _location) public {
        drivers[msg.sender].location = _location;
        bool isDriverInArray = false;
        for (uint256 i = 0; i < driverArray.length; i++) {
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
        for (uint256 i = 0; i < driverArray.length; i++) {
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
        for (uint256 i = 0; i < driverArray.length; i++) {
            address driverAddress = driverArray[i];
            locations[i] = drivers[driverAddress].location;
            models[i] = drivers[driverAddress].model;
        }
        return (driverArray, locations, models);
    }

    struct RideSelect {
        address userAddress;
        address driverAddress;
        string pickup;
        string dropoff;
        bool accept;
        bool reject;
        string amount;
    }

    struct rideHistory {
        address userAddress;
        address driverAddress;
        string pickup;
        string dropoff;
        string amount;
        uint256 date;
    }

    rideHistory[] rideHistoryArray;
    RideSelect[] rideSelectArray;

    function addData(
        address _driverAddress,
        string memory _pickup,
        string memory _dropoff,
        string memory _amount
    ) public {
        RideSelect memory newData = RideSelect({
            userAddress: msg.sender,
            driverAddress: _driverAddress,
            pickup: _pickup,
            dropoff: _dropoff,
            accept: false,
            reject: false,
            amount: _amount
        });
        rideSelectArray.push(newData);
    }

    function getData() public view returns (RideSelect[] memory) {
        return rideSelectArray;
    }

    function removeData() public {
        address _userAddress = msg.sender;
        uint256 i = 0;
        while (i < rideSelectArray.length) {
            if (rideSelectArray[i].userAddress == _userAddress) {
                rideSelectArray[i] = rideSelectArray[
                    rideSelectArray.length - 1
                ];
                rideSelectArray.pop();
            } else {
                i++;
            }
        }
    }

    function acceptRide(address _userAddress, address _driverAddress) public {
        if (bytes(drivers[_driverAddress].location).length > 0) {
            drivers[msg.sender].location = "";
        }
        for (uint256 i = 0; i < driverArray.length; i++) {
            if (driverArray[i] == _driverAddress) {
                driverArray[i] = driverArray[driverArray.length - 1];
                driverArray.pop();
                break;
            }
        }
        for (uint256 i = 0; i < rideSelectArray.length; i++) {
            if (
                rideSelectArray[i].userAddress == _userAddress &&
                rideSelectArray[i].driverAddress == _driverAddress
            ) {
                rideSelectArray[i].accept = true;
                return;
            }
        }
    }

    function rejectRide(address _userAddress, address _driverAddress) public {
        for (uint256 i = 0; i < rideSelectArray.length; i++) {
            if (
                rideSelectArray[i].userAddress == _userAddress &&
                rideSelectArray[i].driverAddress == _driverAddress
            ) {
                rideSelectArray[i].reject = true;
                return;
            }
        }
    }

    function payDriver(
        address _driverAddress,
        address _userAddress,
        uint256 _driverRating
    ) public payable {
        for (uint256 i = 0; i < rideSelectArray.length; i++) {
            if (
                rideSelectArray[i].userAddress == _userAddress &&
                rideSelectArray[i].driverAddress == _driverAddress &&
                rideSelectArray[i].accept == true
            ) {
                rideHistoryArray.push(
                    rideHistory(
                        rideSelectArray[i].userAddress,
                        rideSelectArray[i].driverAddress,
                        rideSelectArray[i].pickup,
                        rideSelectArray[i].dropoff,
                        rideSelectArray[i].amount,
                        block.timestamp
                    )
                );

                rideSelectArray[i] = rideSelectArray[
                    rideSelectArray.length - 1
                ];
                rideSelectArray.pop();
                break;
            }
        }
        drivers[_driverAddress].rating =
            (_driverRating + drivers[_driverAddress].rating) /
            2;
        payable(_driverAddress).transfer(msg.value);
    }

    function displayRideHistory() public view returns (rideHistory[] memory) {
        return rideHistoryArray;
    }

    function updateUserRating(address userAddress, uint256 rating) public {
        User storage user = users[userAddress];
        user.rating = (rating + user.rating) / 2;
    }
}
