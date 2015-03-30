$(document).on('ready page:load statusesLoaded', function() {
  $(".uppie, .downie").click( function() {
    if ($(this).hasClass('highlighted')) {
      $(this).removeClass('highlighted');
    } else {
      $(this).siblings().removeClass('highlighted');
      $(this).addClass('highlighted');
    }
  });
});
