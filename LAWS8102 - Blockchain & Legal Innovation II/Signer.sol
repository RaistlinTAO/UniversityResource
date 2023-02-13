//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import '@openzeppelin/contracts/utils/math/SafeMath.sol';
import '@openzeppelin/contracts/access/Ownable.sol';

contract Signer is Ownable{

  using SafeMath for uint256;

  //EVENTS
  event createFile(address owner, string fileHash, uint256 validTo);
  event userVerification(address owner, uint256 timestamp);
  event userSignature(address owner, uint256 timestamp);
  event userSignatureRequest(address owner, uint256 timestamp);

  struct File {
    address owner;
    string promotion;
    string fileHash;
    uint256 validFrom;
    uint256 validTo;
    uint256 timestamp;
    bool valid;
  }
  struct Verified{
    address owner;
    string name;
    bool valid;
    bool requested;
  }
  mapping(address => Verified) public verified;
  mapping(string => File) public uploads;
  
  /**
    @param _name name for the owner
  */
  constructor(string memory _name){
    Verified memory newVerified = Verified({
      owner: msg.sender,
      name: _name,
      valid: true,
      requested: true
    });
    verified[msg.sender] = newVerified;
  }

  /**
    @notice Get information from a hash file
    @param _newOwner new owner address
  */
  function transferOwner(address _newOwner) public {
    verified[msg.sender].owner = _newOwner;
    transferOwnership(_newOwner);
  }

  /**
    @notice Get information from a hash file
    @param _hash hash to get information
  */
  function getInformation(string memory _hash) public view returns (address, string memory, string memory, uint256, uint256, uint256, bool) {
    File memory temp = uploads[_hash];
    require(temp.valid, "File not found");

    return (temp.owner, temp.promotion, temp.fileHash, temp.validFrom, temp.validTo, temp.timestamp, temp.valid);
  }

  /**
    @notice Get information from a verified user
    @param _owner address to get information
  */
  function getOwnerInformation(address _owner) public view returns (address, string memory, bool, bool) {
    Verified memory temp = verified[_owner];

    return (temp.owner, temp.name, temp.valid, temp.requested);
  }

  /**
    @notice uploads a new file
    @param _promotion promotion title
    @param _fileHash file hash
    @param _validFrom valid time from
    @param _validTo valid time to
  */
  function uploadFile(string memory _promotion, string memory _fileHash, uint256 _validFrom, uint256 _validTo) public{
    require(verified[msg.sender].valid, "Not a verified user");
    require(!uploads[_fileHash].valid, "Already uploaded");
    File memory newFile = File({
      owner: msg.sender,
      promotion: _promotion,
      fileHash: _fileHash,
      validFrom: _validFrom,
      validTo: _validTo,
      timestamp: block.timestamp,
      valid: true
    });
    uploads[_fileHash] = newFile;

    emit createFile(msg.sender, _fileHash, _validTo);
  }



  /**
    @notice request for address file signing
    @param _name name of the user/company
  */
  function requestSignature(string memory _name) public{
    require(!verified[msg.sender].valid, "already signed");
    Verified memory newVerified = Verified({
      owner: msg.sender,
      name: _name,
      valid: false,
      requested: true
    });
    verified[msg.sender] = newVerified;

    emit userSignatureRequest(msg.sender, block.timestamp);
  }

  /**
    @notice address file signing
    @param _owner address of the user/company to verify
  */
  function signing(address _owner) public onlyOwner{
    require(!verified[_owner].valid, "already a signed document");
    require(verified[_owner].requested, "user have not permitted");

    verified[_owner].valid = true;

    emit userSignature(_owner, block.timestamp);
  }

  /**
    @notice address to unveridy
    @param _owner address of the user/company to unverify
  */
  function unverify(address _owner) public onlyOwner{
    require(verified[_owner].valid, "already a unverified user");

    verified[_owner].valid = false;

    emit userUnverification(_owner, block.timestamp);
  }

}