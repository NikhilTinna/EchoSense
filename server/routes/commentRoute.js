const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");

const commentRouter = express.Router();
const prisma = new PrismaClient();

commentRouter.get("/:id",async(req,res)=>{
    const id=req.params.id;

    const posts=
    res.json(posts)
})

commentRouter.post("",async(req,res)=>{
    const newComment=await prisma.comment.create({data:req.body})
    res.json(newComment)
})

module.exports = commentRouter;
