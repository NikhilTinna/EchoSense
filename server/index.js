const express = require("express");
const cors = require("cors");
const bodyparser = require("body-parser");
const cloudinary = require("cloudinary");
const { PrismaClient } = require("@prisma/client");


const app = express();

const prisma = new PrismaClient();
app.get(express.json());
app.get(cors());
app.use(bodyparser.json());

app.get("/", async (req, res) => {
  const users = await prisma.user.findMany();
  res.json(users);
});

app.post("/signup",async(req,res)=>{
    const newUser=await prisma.user.create({data:req.body})
    res.json(newUser)
})

app.get("/posts/:id",async(req,res)=>{
    const id=req.params.id;

    const posts=await prisma.post.findMany({where:{userId:id},include:{
        user:true,
        quotePost:true
    }})
    res.json(posts)
})

app.post("/posts",async(req,res)=>{
    const newPost=await prisma.post.create({data:req.body})
    res.json(newPost)
})

app.post("/posts/reply",async(req,res)=>{
    const newPost=await prisma.post.create({data:req.body})
    res.json(newPost)
})

app.get("/comments/:id",async(req,res)=>{
    const id=req.params.id;

    const posts=
    res.json(posts)
})

app.post("/comments",async(req,res)=>{
    const newComment=await prisma.comment.create({data:req.body})
    res.json(newComment)
})

app.listen(3000, () => {});
