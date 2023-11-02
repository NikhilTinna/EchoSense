const express = require("express");
const { PrismaClient } = require("@prisma/client");
const verifyJWT = require("../utilities/verify_jwt");

const likeRouter = express.Router();
const prisma = new PrismaClient();

//like a post
likeRouter.post("/post", async (req, res) => {
  const { userId, postId } = req.body;

  const like = await prisma.like.create({
    data: {
      userId,
      postId,
    },
  });

  res.json(like);
});

//renove like from post
likeRouter.post("/post/remove", async (req, res) => {
  const { userId, postId } = req.body;
  const comment = await prisma.like.deleteMany({
    where: {
      userId,
      postId,
    },
  });
  res.json("like removed");
});

//get likes for a particular post
likeRouter.get("/post/:postId", async (req, res) => {
  const { postId } = req.params;
  const postLikes = await prisma.like.count({
    where: {
      postId,
    },
  });
  res.json(postLikes);
});

//check if post liked by a user
likeRouter.get("/post/likedByUser/:userId/:postId", async (req, res) => {
  const { userId, postId } = req.params;
  const postLikedByuser = await prisma.like.findFirst({
    where: {
      userId,
      postId,
    },
  });
  if (postLikedByuser) {
    res.json(true);
  } else {
    res.json(false);
  }
});

//get all liked posts for a user
likeRouter.get("/posts/user/:userId", async (req, res) => {
  const userId = req.params;
  const likedPosts = await prisma.like.findMany({
    where:userId,
   
    include: {
      post: {
        include: {
          user: true,
          quotePost: {
            include: {
              user: true,
            },
          },
        },
      },
    },
    orderBy: {
      createdAt: "desc",
    },
  });
  const filteredList=likedPosts.filter(map=>map.postId!==null)
  res.json(filteredList);
});

//like a comment
likeRouter.post("/comment", async (req, res) => {
  const { userId, commentId } = req.body;

  const like = await prisma.like.create({
    data: {
      userId,
      commentId,
    },
  });

  res.json("liked comment");
});

//remove like from comment
likeRouter.post("/comment/remove", async (req, res) => {
  const { userId, commentId } = req.body;
  const comment = await prisma.like.deleteMany({
    where: {
      userId,
      commentId,
    },
  });
  res.json("like removed");
});

//get likes for a particular comment
likeRouter.get("/comment/:commentId", async (req, res) => {
  const { commentId } = req.params;
  const postLikes = await prisma.like.count({
    where: {
      commentId,
    },
  });
  res.json(postLikes);
});

//check if comment liked by a user
likeRouter.get("/comment/likedByUser/:userId/:commentId", async (req, res) => {
  const { userId, commentId } = req.params;
  const commentLikedByuser = await prisma.like.findFirst({
    where: {
      userId,
      commentId,
    },
  });
  if (commentLikedByuser) {
    res.json(true);
  } else {
    res.json(false);
  }
});

//like a reply
likeRouter.post("/reply", async (req, res) => {
  const { userId, replyId } = req.body;

  const like = await prisma.like.create({
    data: {
      userId,
      replyId,
    },
  });

  res.json("liked comment");
});

//remove like from reply
likeRouter.post("/reply/remove", async (req, res) => {
  const { userId, replyId } = req.body;
  const reply = await prisma.like.deleteMany({
    followerId_followingId: {
      followerId: followerId,
      followingId: followingId,
    },
  });
  res.json("like removed");
});

//get likes for a particular reply
likeRouter.get("/reply/:replyId", async (req, res) => {
  const { replyId } = req.params;
  const postLikes = await prisma.like.count({
    where: {
      replyId,
    },
  });
  res.json(postLikes);
});

//check if reply liked by a user
likeRouter.get("/reply/likedByUser/:userId/:replyId", async (req, res) => {
  const { userId, replyId } = req.params;
  const replyLikedByuser = await prisma.like.findFirst({
    where: {
      userId,
      replyId,
    },
  });
  if (replyLikedByuser) {
    res.json(true);
  } else {
    res.json(false);
  }
});

module.exports = likeRouter;
