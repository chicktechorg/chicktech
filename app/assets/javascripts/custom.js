$(function() {
  $('#add-job-button').click(function() {
    $(this).next('div#new-job').slideToggle();
  });
});
