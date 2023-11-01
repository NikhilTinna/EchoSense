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
       post:true
      
    },orderBy:{
        createdAt:"asc"
      }},)
    res.json(posts)
})

replyRouter.post("",async(req,res)=>{
    const newReply=await prisma.reply.create({data:req.body})
    res.json(newReply)
})

//get total reply count for a comment
replyRouter.get("/count/:id",async(req,res)=>{
    const id=req.params.id;

    const replyCount=await prisma.reply.count({where:{commentId:id}})

    res.json(replyCount)
})

module.exports = replyRouter;
