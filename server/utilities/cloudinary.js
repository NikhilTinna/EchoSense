const cloudinary=require("cloudinary").v2;
       
cloudinary.config({ 
      cloud_name: 'dtpuufjan', 
      api_key: '512997975799899', 
      api_secret: 'A04rOqp8Il70j97NPpdSEGbf7uI' 
    });

    module.exports=cloudinary;
