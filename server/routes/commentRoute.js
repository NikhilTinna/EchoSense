const express = require("express");
const { PrismaClient } = require("@prisma/client");
const verifyJWT=require("../utilities/verify_jwt")

const commentRouter = express.Router();
const prisma = new PrismaClient();

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

commentRouter.post("",async(req,res)=>{
    const newComment=await prisma.comment.create({data:req.body})
    res.json(newComment)
})

module.exports = commentRouter;
