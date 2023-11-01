const express = require("express");
const { PrismaClient } = require("@prisma/client");
const verifyJWT=require("../utilities/verify_jwt")

const commentRouter = express.Router();
const prisma = new PrismaClient();


// get all comments for a post
commentRouter.get("/:id",async(req,res)=>{
    const id=req.params.id;

    const posts=await prisma.comment.findMany({where:{postId:id},include:{
        user:true,
        post:true
    },orderBy:{
        createdAt:"desc"
      }},)
    res.json(posts)
})
// create a comment
commentRouter.post("",async(req,res)=>{
    const newComment=await prisma.comment.create({data:req.body})
    res.json(newComment)
})

//get total comment count for a post
commentRouter.get("/count/:id",async(req,res)=>{
    const id=req.params.id;

    const commentCount=await prisma.comment.count({where:{postId:id}})

    res.json(commentCount)
})

module.exports = commentRouter;
