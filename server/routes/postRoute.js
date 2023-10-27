const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");

const postRouter = express.Router();
const prisma = new PrismaClient();

postRouter.get("/:id",async(req,res)=>{
    const id=req.params.id;

    const posts=await prisma.post.findMany({where:{userId:id},include:{
        user:true,
        quotePost:true
    }})
    res.json(posts)
})

postRouter.post("",async(req,res)=>{
    const newPost=await prisma.post.create({data:req.body})
    res.json(newPost)
})

postRouter.post("/reply",async(req,res)=>{
    const newPost=await prisma.post.create({data:req.body})
    res.json(newPost)
})


module.exports = postRouter;
