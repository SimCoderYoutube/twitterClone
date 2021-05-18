const functions = require("firebase-functions");

const admin = require('firebase-admin');
admin.initializeApp();

const db = admin.firestore();

exports.addLike = functions.firestore.document('/posts/{postId}/likes/{userId}')
.onCreate((snap, context) => {
    return db
    .collection("posts")
    .doc(context.params.postId)
    .update(
        {
            likesCount: admin.firestore.FieldValue.increment(1)
        })
})

exports.deleteLike = functions.firestore.document('/posts/{postId}/likes/{userId}')
.onDelete((snap, context) => {
    return db
    .collection("posts")
    .doc(context.params.postId)
    .update(
        {
            likesCount: admin.firestore.FieldValue.increment(-1)
        })
})


exports.addRetweet = functions.firestore.document('/posts/{postId}/retweets/{userId}')
.onCreate((snap, context) => {
    return db
    .collection("posts")
    .doc(context.params.postId)
    .update(
        {
            retweetsCount: admin.firestore.FieldValue.increment(1)
        })
})

exports.deleteRetweet = functions.firestore.document('/posts/{postId}/retweets/{userId}')
.onDelete((snap, context) => {
    return db
    .collection("posts")
    .doc(context.params.postId)
    .update(
        {
            retweetsCount: admin.firestore.FieldValue.increment(-1)
        })
})