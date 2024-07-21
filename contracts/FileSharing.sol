// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FileSharing {
    struct File {
        string cid;
        address owner;
        mapping(address => bool) accessList;
    }

    mapping(uint256 => File) public files;
    uint256 public fileCount;

    event FileAdded(uint256 fileId, string cid, address owner);
    event AccessGranted(uint256 fileId, address grantee);
    event AccessRevoked(uint256 fileId, address revokee);

    function grantAccess(uint256 fileId, address grantee, string memory cid) public {
        File storage file = files[fileId];

        // If the file does not exist, add it
        if (file.owner == address(0)) {
            fileCount++;
            file.cid = cid;
            file.owner = msg.sender;
            emit FileAdded(fileCount, cid, msg.sender);
        } else {
            require(msg.sender == file.owner, "Only the owner can grant access");
        }

        file.accessList[grantee] = true;
        emit AccessGranted(fileId, grantee);
    }

    function revokeAccess(uint256 fileId, address revokee) public {
        File storage file = files[fileId];
        require(file.owner != address(0), "File does not exist");
        require(msg.sender == file.owner, "Only the owner can revoke access");
        file.accessList[revokee] = false;
        emit AccessRevoked(fileId, revokee);
    }

    function hasAccess(uint256 fileId, address user) public view returns (bool) {
        File storage file = files[fileId];
        return file.owner != address(0) && file.accessList[user];
    }
}