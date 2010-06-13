jQuery(function() {
  function pathFor(link) {
    return $(link).parents("li").map(function() {
      return $(this).find("> a").text();
    }).get().reverse();
  }

  $("#tree li a").click(function() {
    // console.log(pathFor(this));
    return false;
  });

  $("a:contains(controllers)").parent().addClass("active");

  $("#methods, #details").bind("scroll", function(e) {
    if($(this).scrollTop() == 4) $(this).scrollTop($(this).data("top"));
    else $(this).data("top", $(this).scrollTop());
  });

  $(".yellow").live("webkitTransitionEnd", function() {
    $(this).removeClass("yellow");
  });

  var currentURL;

  function gotoName(name) {
    if(name) {
      var element = $("[id='" + name + "']");
      var top = element.offset().top;
      $("#details").scrollTop(top);
      element.addClass("yellow");
    }
  }

  $("div.method-list li a").click(function(e) {
    e.preventDefault();

    var url  = $(this).attr("href");
    var moduleURL = url.match(/(.*)(#.*)/);
    moduleURL = moduleURL ? moduleURL[1] : url;
    var name = $(this).attr("data-name");

    $("#methods a").removeClass("current");
    $(this).addClass("current");

    if(currentURL == moduleURL) {
      gotoName(name);
    } else {
      currentURL = moduleURL;

      $.get(url, function(html) {
        $("#details").replaceWith($("#details", html));
        gotoName(name);
      });
    }
    return false;
  });
});