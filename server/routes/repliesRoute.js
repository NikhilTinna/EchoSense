const express = require("express");
const { PrismaClient } = require("@prisma/client");
const verifyJWT=require("../utilities/verify_jwt")

const replyRouter = express.Router();
const prisma = new PrismaClient();

//get all replies for a comment
replyRouter.get("/:id",async(req,res)=>{
    const id=req.params.id;

    const posts=await prisma.reply.findMany({where:{commentId:id},include:{
        user:true,
        post:true,
        comment:true
      
    },orderBy:{
        createdAt:"desc"
      }},)
    res.json(posts)
})

replyRouter.post("",async(req,res)=>{
    const newReply=await prisma.reply.create({data:req.body})
    res.json(newReply)
})

module.exports = replyRouter;
