const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
const nodemailer = require("nodemailer");
const Mailgen = require("mailgen");
const verifyJWT=require("../utilities/verify_jwt")
const upload=require("../utilities/multer")
const cloudinary=require("../utilities/cloudinary")
require("dotenv").config();

const userRouter = express.Router();
const prisma = new PrismaClient();

userRouter.post("/signup", async (req, res) => {
  const { name, username, email, password } = req.body;
  const hashedpassword = await bcrypt.hash(password, 8);
  const newUser = await prisma.user.create({
    data: {
      name,
      username,
      email,
      password: hashedpassword,
    },
  });
  console.log(newUser);

  const token = jwt.sign(newUser, process.env.SECRET_KEY);

  res.json(token);
});

userRouter.post("/verify", async (req, res) => {
  try {
    const { name, username, email, password } = req.body;

    // const existingUsername = await prisma.user.findFirst({
    //   where: {
    //     username,
    //   },
    // });
    // if (existingUsername) {
    //   return res.status(400).json({ msg: "Username is already taken!" });
    // }

    // const existingUser = await prisma.user.findFirst({
    //   where: {
    //     email,
    //   },
    // });
    // if (existingUser) {
    //   return res
    //     .status(400)
    //     .json({ msg: "User with same email already exists!" });
    // }

    const randomNumber = Math.floor(1000 + Math.random() * 9000);
    const transporter = nodemailer.createTransport({
      service: "Gmail", // Use the service appropriate for your email provider
      auth: {
        user: process.env.EMAIL_USERNAME, // Your email address
        pass: process.env.EMAIL_PASSWORD, // Your email password (or an app-specific password)
      },
    });

    const mailOptions = {
      from: "abdulqaderpatel2002@gmail.com", // Sender's email address
      to: email, // Recipient's email address
      subject: "Verify email", // Email subject
      text: `Your otp is ${randomNumber}`, // Email body (plain text)
    };

    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.log(`Error sending email: ${error}`);
      } else {
        res.json(randomNumber);
      }
    });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

userRouter.post("/signin", async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await prisma.user.findFirst({
      where: {
        email,
      },
    });

    if (!user) {
      return res
        .status(400)
        .json({ msg: "User with this email does not exist" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({ msg: "Incorrect password" });
    }

    const token = jwt.sign(user, process.env.SECRET_KEY);

    res.json(token);
  } catch (e) {}
});

userRouter.get("/details/:id", async (req, res) => {
  const id = req.params.id;
  const user = await prisma.user.findFirst({ where: { id } });
  res.json(user);
});

userRouter.post("/username", async (req, res) => {
  const username = req.body.username;
  const existingUsername = await prisma.user.findFirst({ where: { username } });
  if (existingUsername) {
    return res.status(400).json({ msg: "This username has been taken" });
  }
  res.json("success");
});

userRouter.put("/update/text", async (req, res) => {
  const { id, name, username, bio } = req.body;

  const updatedUser = await prisma.user.update({
    where: { id },
    data: {
      username,
      name,
      bio,
    },
  });

  res.json("Profile updated successfully");
});

userRouter.put(
  "/update/image",
  verifyJWT,
  upload.single("image"),
  async (req, res) => {
    cloudinary.uploader.upload(
      req.file.path,
      {
        width:200,height:200,
        folder: `social_media`,
        // public_id: "banner",
      },
      async function (err, result) {
        const { id, name, username, bio } = req.body;

        const updatedUser = await prisma.user.update({
          where: { id },
          data: {
            username,
            name,
            bio,
            picture: result.url,
          },
        });
      
        res.json("Post created successfully");
      }
    );
  }
);

//get all users having following letters in their username

userRouter.get("/search/:id/:text",async(req,res)=>{

  const id=req.params.id;
  const text=req.params.text;
 
  const users = await prisma.user.findMany({
    where: {
      id:{
        not:id
      },
      username: {
        contains: text, 
      
      },

    }
  });
  res.json(users);
})

module.exports = userRouter;
