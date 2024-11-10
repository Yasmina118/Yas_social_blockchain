// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MiniSocial {
    event NewPostEvent(string Message, address PostOwner, uint PostTime, uint PostId);
    event PostUpdatedEvent(string NewMessage, uint PostId);

    struct Post {
        uint id;
        string message;
        address author;
        uint num_likes;
        uint num_dislikes;
        address[] likedBy;
        address[] dislikedBy;
        uint256 createdAt;
        uint256 updatedAt;
    }

    Post[] private Posts;

    function GetPostAuthor(uint id) public view returns(address) {
        return Posts[id].author;
    }

    function GetPostLikes(uint id) public view returns(uint){
        return Posts[id].num_likes;
    }

    function GetPostDisLikes(uint id) public view returns(uint){
        return Posts[id].num_dislikes;
    }

    function GetPostCreatedAt(uint id) public view returns(uint256) {
        return Posts[id].createdAt;
    }

    function GetPostUpdatedAt(uint id) public view returns(uint256) {
        return Posts[id].updatedAt;
    }

    function getTotalPosts() public view returns(uint) {
        return Posts.length;
    }

    function GetPosts() public view returns(Post[] memory) {
        return Posts;
    }

    function getPost(uint index) public view returns (string memory, address){
        return (Posts[index].message, Posts[index].author);
    }

    function hasLiked(uint id, address user) internal view returns (bool) {
        for (uint i = 0; i < Posts[id].likedBy.length; i++) {
            if (Posts[id].likedBy[i] == user) {
                return true;
            }
        }
        return false;
    }

    function hasDisliked(uint id, address user) internal view returns (bool) {
        for (uint i = 0; i < Posts[id].dislikedBy.length; i++) {
            if (Posts[id].dislikedBy[i] == user) {
                return true;
            }
        }
        return false;
    }

    function addLike(uint id) public {
        require(!hasLiked(id, msg.sender), "User has already liked this post.");
        require(!hasDisliked(id, msg.sender), "User cannot like a post they disliked.");
        Posts[id].num_likes++;
        Posts[id].likedBy.push(msg.sender);
    }

    function addDisLike(uint id) public {
        require(!hasDisliked(id, msg.sender), "User has already disliked this post.");
        require(!hasLiked(id, msg.sender), "User cannot dislike a post they liked.");
        Posts[id].num_dislikes++;
        Posts[id].dislikedBy.push(msg.sender);
    }

    function publishPost(string memory _message) public {
        require(keccak256(abi.encodePacked(_message)) != keccak256(abi.encodePacked("")), "Post cannot be empty.");
        require(bytes(_message).length <= 140, "Post is too long.");
        uint index = Posts.length + 1;
        uint num_likes;
        uint num_dislikes;
        address author = msg.sender;
        address[] memory likedBy;
        address[] memory dislikedBy;
        uint256 createdAt = block.timestamp;
        Posts.push(Post(index, _message, author, num_likes, num_dislikes, likedBy, dislikedBy, createdAt, createdAt));
        emit NewPostEvent(_message, author, createdAt, index);
    }

    function updatePost(uint _postId, string memory _newMessage) public {
        require(_postId >= 1 && _postId <= Posts.length, "Invalid post ID");
        require(Posts[_postId-1].author == msg.sender, "Only the author can update the post");
        require(bytes(_newMessage).length <= 140, "Post is too long.");
        Posts[_postId-1].message = _newMessage;
        Posts[_postId-1].updatedAt = block.timestamp;
        emit PostUpdatedEvent(_newMessage, _postId);
    }
}