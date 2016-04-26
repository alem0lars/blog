require("lunr");

// Get temporary data from `window` and cleanup.
window.initSearchPipeline();
searchIndexPath = window.searchIndexPath;
delete window.searchIndexPath;
delete window.initSearchPipeline;

// Download index data.
var lunrIndex = null;
var lunrData  = null;
$.ajax({
  url: searchIndexPath,
  cache: true,
  method: 'GET',
  success: function(data) {
    lunrData = data;
    lunrIndex = lunr.Index.load(lunrData.index);
  }
});
console.log(lunrData);