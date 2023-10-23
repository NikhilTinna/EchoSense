const express=require("express")
const cors=require("cors")
const bodyparser=require("body-parser")
const cloudinary=require("cloudinary")
const {PrismaClient}=require("@prisma/client")

const app=express()

app.get(express.json())
app.get(cors())
app.use(bodyparser.json())


app.listen(3000,(()=>{
    
}))

