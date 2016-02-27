require("jquery");
require("materialize-css/dist/js/materialize.js");

$(document).ready(function() {
  // NOTE: Keep classes in sync with tag helpers.
  $(".trigger-tooltip").tooltip({delay: 48});
  $(".trigger-sidenav").sideNav();
  $(".trigger-dropdown").dropdown();

  // Initialize modals.
  $(".trigger-modal").each(function() {
    var $element = $(this);
    $element.leanModal({
      dismissible: String($element.data("dismissible")).toLowerCase() === "true",
      opacity: parseInt($element.data("opacity")),
      in_duration: parseFloat($element.data("in-duration")),
      out_duration: parseFloat($element.data("out-duration"))
    });
  });

  // NOTE: Not needed at the moment.
  //$('.collapsible').collapsible();
  //$('.materialboxed').materialbox();
  //$('.parallax').parallax();
  //$('.scrollspy').scrollSpy();
});

require("./components/search-box/main.js");
