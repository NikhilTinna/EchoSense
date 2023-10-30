const express = require("express");
const { PrismaClient } = require("@prisma/client");
const verifyJWT=require("../utilities/verify_jwt")

const likeRouter = express.Router();
const prisma = new PrismaClient();

//like a post
likeRouter.post("/post",async(req,res)=>{
    
    const {userId,postId}=req.body;

    const like=await prisma.like.create({
        data:{
            userId,postId
        }
    })

    res.json(like)
})

//renove like from post
likeRouter.post("/post/remove",async(req,res)=>{
    const {userId,postId}=req.body
    const comment=await prisma.like.deleteMany({
        where:{
            userId,postId
        }
    })
    res.json("like removed")
})

likeRouter.get("/post/:postId",async(req,res)=>{
    const {postId}=req.params
    const postLikes=await prisma.like.count({
        where:{
            postId
        }
    })
    res.json(postLikes)
})

likeRouter.get("/post/likedByUser/:userId/:postId",async(req,res)=>{
    const {userId,postId}=req.params
    const postLikedByuser=await prisma.like.findFirst({
        where:{
            userId,postId
        }
    })
    if(postLikedByuser)
    {
        res.json(true)
    }
    else{
        res.json(false)
    }
})

//get all liked posts for a user
likeRouter.get("/posts/user/:userId",async(req,res)=>{
    const userId=req.params;
    const likedPosts=await prisma.like.findMany({where:userId,include:{
        post:{
            include:{
                user:true,
                quotePost:{
                    include:{
                        user:true
                    }
                }
                
            }
        }

        
     
    },orderBy:{
        createdAt:"desc"
      }})
    res.json(likedPosts)
})




module.exports = likeRouter;
