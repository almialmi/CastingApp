const EventForComputation = require('../models/event.models');

module.exports.registerEvent =(req,res,next)=>{
    var eventForComputation = new EventForComputation({
        name:req.body.name,
        description:req.body.description,
        category:req.body.category,
        startDate:req.body.startDate,
        endDate:req.body.endDate
    });
    eventForComputation.save((err,doc)=>{
        if(!err)
            res.send(201,doc);
        else{
            if(err)
                res.status(422).send(err);
            else
                return next(err);    
        }
            
    });

}

module.exports.showEvents=(req,res)=>{
    EventForComputation.find({__v:0},(err,result)=>{
        if(err){
            res.send(err)
        }else{
            res.send(result)
        }
    });

}

module.exports.updateEvent =(req,res)=>{
    if(!req.body.name && !req.body.description && !req.body.category && !req.body.startDate && !req.body.endDate) {
        return res.status(400).send({
            message: " All this contents cann't be empty"
        });
    }
    
    EventForComputation.findByIdAndUpdate(req.params.id, {
        $set:{
            name:req.body.name,
            description:req.body.description,
            category:req.body.category,
            startDate:req.body.startDate,
            endDate:req.body.endDate

        }
        
    }, {new: true})
    .then(eve => {
        if(!eve) {
            return res.status(404).send({
                message: "Event not found with id " + req.params.id
            });
        }
        res.status(200).send({
            message:"successfully update Event",
            success:true
        });
    }).catch(err => {
        if(err.kind === 'ObjectId') {
            return res.status(404).send({
                message: "Event not found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Error updating Event with id " + req.params.id
        });
    });

}
module.exports.deleteEvent=(req,res)=>{
    EventForComputation.findByIdAndRemove(req.params.id)
    .then(eve => {
        if(!eve) {
            return res.status(404).send({
                message: "Event not found with id " + req.params.id
            });
        }
        res.send({message: "Event deleted successfully!"});
    }).catch(err => {
        if(err.kind === 'ObjectId' || err.name === 'NotFound') {
            return res.status(404).send({
                message: "Event found with id " + req.params.id
            });                
        }
        return res.status(500).send({
            message: "Could not delete Event with id " + req.params.id
        });
    });

}

module.exports.showRemainingTimeAndExpried=(req,res)=>{
    const endDate=Date();
    const startDate = Date();
    
    EventForComputation.find({},{startDate:true,endDate:true},toArray((err,data)=>{
        if(err) { 
            return res.send(err); 
        }else{
        console.log(data);
        startDate = data[0];
        endDate = data[1];
        var deadline = new Date(endDate).getTime();
        var x = setInterval(function() {
        var startline = new Date(startDate).getTime();
        var t = deadline - startline;
        var days = Math.floor(t/(1000 * 60 * 60 * 24));
        var hours = Math.floor((t%(1000*60*60*24))/(1000*60*60));
        var minutes = Math.floor((t%(1000*60*60))/(1000*60));
        var seconds =Math.floor((t%(1000*60))/1000);
        var remaining= days + "d" + hours + "hr" + minutes + "m" + seconds + "s";
        console.log(remaining);
        res.status(200).send({
            message:remaining
        });

            if (t < 0) {
                clearInterval(x);
                res.status(200).send({
                    message:"The event is Closed!!"
                });
        }

        }, 1000);

        }
        

    }));
}


