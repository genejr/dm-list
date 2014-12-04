Tinytest.add("Notices collection works", function(test) {
  test.equal(Meteor.notices.find({}).count(), 0);

  Meteor.Notices.throw('A new notice!', 'info');
  test.equal(Meteor.notices.find({}).count(), 1);

  Meteor.notices.remove({});
});

Tinytest.addAsync("Notices template works", function(test, done) {  
  Meteor.Notices.throw('A new notice!');
  test.equal(Meteor.notices.find({seen: false}).count(), 1);

  // render the template
  OnscreenDiv(Spark.render(function() {
    return Template.meteorNotices();
  }));

  // wait a few milliseconds
  Meteor.setTimeout(function() {
    test.equal(Meteor.notices.find({seen: false}).count(), 0);
    test.equal(Meteor.notices.find({}).count(), 1);
    Meteor.Notices.clear();

    test.equal(Meteor.notices.find({seen: true}).count(), 0);
    done();
  }, 500);
});