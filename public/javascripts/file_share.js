// use to give the preview of details for an event below a calendar
var updateEventDescription = function(event, jsEvent) {
  $("#event_quick_description")[0].innerHTML = "";
  $("#event_quick_description").append(
    $("<h3/>").append(
      $('<a/>', { text : event.title, href : event.url })
    )
  );
  $("#event_quick_description")[0].innerHTML += "Location: " + event.location + "<br/>";
  $("#event_quick_description")[0].innerHTML += event.description;
  
  $("#event_quick_description").show();
}


jQuery(function($) {
  $('a.show_hide_link').attach(ShowHideLink);
});

/*
http://www.learningjquery.com/2007/08/clearing-form-data
*/
$.fn.clearForm = function() {
  return this.each(function() {
    var type = this.type, tag = this.tagName.toLowerCase();
    if (tag == 'form')
      return $(':input',this).clearForm();
    if (type == 'text' || type == 'password' || tag == 'textarea')
      this.value = '';
    else if (type == 'checkbox' || type == 'radio')
      this.checked = false;
    else if (tag == 'select')
      this.selectedIndex = -1;
  });
};
