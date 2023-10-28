const express = require("express");
const { PrismaClient } = require("@prisma/client");
const verifyJWT=require("../utilities/verify_jwt")

const likeRouter = express.Router();
const prisma = new PrismaClient();

likeRouter.post("/post",async(req,res)=>{
    
    const {userId,postId}=req.body;

    const like=await prisma.like.create({
        data:{
            userId,postId
        }
    })

    res.json(like)
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

likeRouter.post("",verifyJWT,async(req,res)=>{
    const newComment=await prisma.comment.create({data:req.body})
    res.json(newComment)
})

module.exports = likeRouter;
