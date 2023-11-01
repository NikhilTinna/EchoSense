const express = require("express");
const { PrismaClient } = require("@prisma/client");
const verifyJWT=require("../utilities/verify_jwt")

const followingRouter = express.Router();
const prisma = new PrismaClient();

//follow a user
followingRouter.post("/follow",async(req,res)=>{
    const {followerId,followingId}=req.body
    const follow=await prisma.following.create({
        data:{
            followerId,followingId
        }
    })
    res.json("User Followed")
})

//unfollow a user
followingRouter.post("/unfollow",async(req,res)=>{
    const {followerId,followingId}=req.body;
    const unfollow=await prisma.following.deleteMany({
        where:{
            followerId,followingId
        }
    })
    res.json("User Unfollowed")
})


//check if a user follows another user
followingRouter.get("/isFollow/:followerId/:followingId",async(req,res)=>{
const followerId=req.params.followerId;
const followingId=req.params.followingId;

const isFollowing=await prisma.following.findFirst({where:{followerId,followingId}})
if(isFollowing)
{
    res.json(true)
}
else{
    res.json(false)
}
})

//get count of user followers and their details
followingRouter.get("/follow/follower/:followerId",async (req,res)=>{
    const followerId=req.params.followerId;
    const followingCount=await prisma.following.count({where:{followerId}})
    const following=await prisma.following.findMany({where:{followerId},include:{
        following:true
    }})
    res.json([followingCount,following]);
})

//get count of user following and their details
followingRouter.get("/follow/following/:followingId",async (req,res)=>{
const followingId=req.params.followingId;
const followerCount=await prisma.following.count({where:{followingId}})
const follower=await prisma.following.findMany({where:{followingId},include:{
    follower:true
}})
res.json([followerCount,follower])
})






module.exports = followingRouter;
