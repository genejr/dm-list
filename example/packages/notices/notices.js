// Local (client-only) collection
Meteor.notices = new Meteor.Collection(null);

Meteor.Notices = {
  throw: function(message, type) {
    if(! this.isSimulation){
      Meteor.notices.insert({message: message, type: type, seen: false});
    
	    setTimeout(function(){
	    	Meteor.Notices.clear();
	    }, 5000);
	}
  },
  clear: function() {
    Meteor.notices.remove({seen: true});
  }  
}