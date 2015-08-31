Moves = new Meteor.Collection('moves');
Stones = new Meteor.Collection('stones');


function ensureCanMoveWhite(user) {
  if (user.services.sandstorm.permissions.indexOf('white') == -1) {
    throw new Meteor.Error(403, "You are not allowed to move white pieces.");
  }
}

function ensureCanMoveBlack(user) {
  if (user.services.sandstorm.permissions.indexOf('black') == -1) {
    throw new Meteor.Error(403, "You are not allowed to move black pieces.");
  }
}

function ensureCanUndo(user) {
  if (user.services.sandstorm.permissions.indexOf('undo') == -1) {
    throw new Meteor.Error(403, "You are not allowed to undo.");
  }
}

Meteor.methods({
  move: function(position) {
    var lastMove = Moves.findOne({}, {sort: {step: -1}});
    var step = 1;
    if(typeof(lastMove) != 'undefined') {
      step = lastMove.step + 1;
    }
    if ((step % 2) == 0) {
      ensureCanMoveWhite(Meteor.user());
    } else {
      ensureCanMoveBlack(Meteor.user());
    }
    if(step > 2) {
      var conflictingMove = Moves.findOne({name: position});
      if(typeof(conflictingMove) != 'undefined') {
        throw new Meteor.Error(500, "Position already played");
      }
    }
    var stone = Stones.findOne({name: position});
    if(!stone)
      throw new Meteor.Error(500, "Position is not valid");
    Moves.insert({name: position, step: step});
  },

  undo: function() {
    ensureCanUndo(Meteor.user());
    var lastMove = Moves.findOne({}, {sort: {step: -1}});
    if (typeof(lastMove) != 'undefined') {
      Moves.remove(lastMove._id);
    }
  },

  reset: function() {
    ensureCanUndo(Meteor.user());
    var moves = Moves.find().fetch();
    _.each(moves, function(move) {
      Moves.remove(move._id);
    });
  }
}
);
