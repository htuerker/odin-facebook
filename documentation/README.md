# FACEBOOK CLONE PROJECT


## Model
1. User - user of app
2. Post - new text based posts
3. Comments - comments on a post
4. Likes - likes on a post

## Auxiliary Models
5. FriendRequest - requests between two user to establish friendship
6. Friendship - represents friendship between two user

### User
- can send friendship request to another user
- can establish friendship with another user
- can submit post
- can comment on a post
- can like a post

### Post
- must be created by a user
- can have comments
- can have likes

### Comment
- must be created by a user
- must be attached to a post

### Likes
- must be created by a user
- must be attached to a post


![Entity Relationship Diagram](./DB%20Diagram.png?raw=true "Entity Relationship Diagram")


