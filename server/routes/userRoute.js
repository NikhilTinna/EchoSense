const express = require("express");
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { PrismaClient } = require("@prisma/client");

const userRouter = express.Router();
const prisma = new PrismaClient();

userRouter.post("/signup", async (req, res) => {
  try {
    const { name, username, email, password } = req.body;

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
    const hashedpassword = await bcrypt.hash(password, 8);

    const newUser = await prisma.user.create({ data:{
        name,username,email,password:hashedpassword
    } });
    res.json(newUser);
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

    return res.json(user);
  } catch (e) {}
});

module.exports = userRouter;
