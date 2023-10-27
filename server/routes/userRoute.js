const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");
const nodemailer = require("nodemailer");
const Mailgen = require("mailgen");
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

  const token = jwt.sign(newUser, process.env.SECRET_KEY);

  res.json(token);
});

userRouter.post("/verify", async (req, res) => {
  try {
    const { name, username, email, password } = req.body;

    const existingUsername = await prisma.user.findFirst({
      where: {
        username,
      },
    });
    if (existingUsername) {
      return res.status(400).json({ msg: "Username is already taken!" });
    }

    const existingUser = await prisma.user.findFirst({
      where: {
        email,
      },
    });
    if (existingUser) {
      return res
        .status(400)
        .json({ msg: "User with same email already exists!" });
    }

    const randomNumber=Math.floor(1000 + Math.random() * 9000);
    const transporter = nodemailer.createTransport({
      service: 'Gmail', // Use the service appropriate for your email provider
      auth: {
        user: 'abdulqaderpatel2002@gmail.com', // Your email address
        pass: 'efbj tvqv wjqg azin', // Your email password (or an app-specific password)
      },
    });
  
    const mailOptions = {
      from: 'abdulqaderpatel2002@gmail.com', // Sender's email address
      to: email, // Recipient's email address
      subject: 'Verify email', // Email subject
      text: `Your otp is ${randomNumber}`, // Email body (plain text)
    };
    
    transporter.sendMail(mailOptions, (error, info) => {
      if (error) {
        console.log(`Error sending email: ${error}`);
      } else {
        res.json(randomNumber)
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

module.exports = userRouter;
