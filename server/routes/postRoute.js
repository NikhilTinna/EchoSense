const express = require("express");
const { PrismaClient } = require("@prisma/client");
const verifyJWT=require("../utilities/verify_jwt")
const upload=require("../utilities/multer")
const cloudinary=require("../utilities/cloudinary")

const postRouter = express.Router();
const prisma = new PrismaClient();



postRouter.post("",verifyJWT,async(req,res)=>{
    const newPost=await prisma.post.create({data:req.body})
    res.json("post created successfully")
})

postRouter.get("/:id",async(req,res)=>{
  const id=req.params.id;

  const posts=await prisma.post.findMany({where:{userId:id},
     orderBy:{
    createdAt:"desc"
  }})
  res.json(posts)
})

postRouter.post("/image",verifyJWT, upload.single("image"), async (req, res) => {
    cloudinary.uploader.upload(
      req.file.path,
      {
        folder: `social_media`,      
       // public_id: "banner",
      },
      async function (err, result) {
        const {description,userId}=req.body;
  
        const post =await prisma.post.create({data:{description,userId, imageurl: result.url}});
        
  
        res.json("Post created successfully");
      }
    );
  });

postRouter.post("/reply",verifyJWT,async(req,res)=>{
    const newPost=await prisma.post.create({data:req.body})
    res.json(newPost)
})


module.exports = postRouter;
