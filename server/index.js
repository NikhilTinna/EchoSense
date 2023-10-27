const express = require("express");
const cors = require("cors");
const bodyparser = require("body-parser");
const cloudinary = require("cloudinary");
const { PrismaClient } = require("@prisma/client");
const userRouter=require("./routes/userRoute")
const postRouter=require("./routes/postRoute")
const commentRouter=require("./routes/commentRoute")


const app = express();

const prisma = new PrismaClient();

//middlewares
app.get(express.json());
app.get(cors());
app.use(bodyparser.json());

//routes
app.use("/user",userRouter)
app.use("/posts",postRouter)
app.use("/comments",commentRouter)

app.listen(3000, () => {});
