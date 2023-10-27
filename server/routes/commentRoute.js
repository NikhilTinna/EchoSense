const express = require("express");
const { PrismaClient } = require("@prisma/client");
const verifyJWT=require("../utilities/verify_jwt")

const commentRouter = express.Router();
const prisma = new PrismaClient();

commentRouter.get("/:id",async(req,res)=>{
    const id=req.params.id;

    const posts=
    res.json(posts)
})

commentRouter.post("",verifyJWT,async(req,res)=>{
    const newComment=await prisma.comment.create({data:req.body})
    res.json(newComment)
})

module.exports = commentRouter;
