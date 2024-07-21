// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FileSharing {
    struct File {
        string cid;
        address owner;
        mapping(address => string) accessList; // Mapping from address to encrypted key
    }

    mapping(uint256 => File) public files;
    mapping(address => uint256[]) private userFiles; // Mapping from address to list of file IDs
    uint256 public fileCount;

    event FileAdded(uint256 fileId, string cid, address owner);
    event AccessGranted(uint256 fileId, address grantee, string encryptedKey);
    event AccessRevoked(uint256 fileId, address revokee);

    function grantAccess(uint256 fileId, address grantee, string memory cid, string memory encryptedKey) public {
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

        file.accessList[grantee] = encryptedKey;
        userFiles[grantee].push(fileId); // Add file ID to user's access list
        emit AccessGranted(fileId, grantee, encryptedKey);
    }

    function revokeAccess(uint256 fileId, address revokee) public {
        File storage file = files[fileId];
        require(file.owner != address(0), "File does not exist");
        require(msg.sender == file.owner, "Only the owner can revoke access");
        delete file.accessList[revokee];

        // Remove file ID from user's access list
        uint256[] storage fileList = userFiles[revokee];
        for (uint256 i = 0; i < fileList.length; i++) {
            if (fileList[i] == fileId) {
                fileList[i] = fileList[fileList.length - 1];
                fileList.pop();
                break;
            }
        }

        emit AccessRevoked(fileId, revokee);
    }

    function hasAccess(uint256 fileId, address user) public view returns (bool) {
        File storage file = files[fileId];
        return file.owner != address(0) && bytes(file.accessList[user]).length > 0;
    }

    function getEncryptedKey(uint256 fileId, address user) public view returns (string memory) {
        File storage file = files[fileId];
        require(file.owner != address(0), "File does not exist");
        require(bytes(file.accessList[user]).length > 0, "No access for this user");
        return file.accessList[user];
    }

    function getUserFiles(address user) public view returns (uint256[] memory) {
        return userFiles[user];
    }
}

