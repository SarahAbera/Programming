const mongoose = require('mongoose');

module.exports = function(req, res, next){
    if(!mongoose.Types.ObjectId.isValid(req.params.id)) 
        return res.status(404).send("Invalid Id");
    next();
}

// function isValidObjectId(id){
//     if(ObjectId.isValid(id)){
//         if((String)(new ObjectId(id)) === id)
//             return true;       
//         return false;
//     }
//     return false;
// }
 