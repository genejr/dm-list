Template.meteorNotices.helpers({
  notices: function() {
    return Meteor.notices.find();
  }
});

Template.meteorNotice.rendered = function() {
  var notice = this.data;
  Meteor.defer(function() {
    Meteor.notices.update(notice._id, {$set: {seen: true}});
  });
};