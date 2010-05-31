// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(function() {
  function pathFor(link) {
    return $(link).parents("li").map(function() {
      return $(this).find("> a").text();
    }).get().reverse();
  }

  $("#tree li a").click(function() {
    console.log(pathFor(this));
    return false;
  });

  $("a:contains(controllers)").parent().addClass("active")
});