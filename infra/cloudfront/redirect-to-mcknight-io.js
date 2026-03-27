// CloudFront Function: armcknight-com-redirect-to-mcknight-io
// Runtime: cloudfront-js-2.0
// Stage: viewer-request
// Distribution: E6BG42FYZHWB0 (armcknight.com, www.armcknight.com)
//
// 301 redirects all requests from armcknight.com to mcknight.io,
// preserving the path and query string.

function handler(event) {
  var request = event.request;
  var newUrl = "https://mcknight.io" + request.uri;
  var queryParts = [];
  for (var key in request.querystring) {
    var val = request.querystring[key];
    if (val.multiValue) {
      for (var i = 0; i < val.multiValue.length; i++) {
        queryParts.push(key + "=" + val.multiValue[i].value);
      }
    } else {
      queryParts.push(key + "=" + val.value);
    }
  }
  if (queryParts.length > 0) {
    newUrl += "?" + queryParts.join("&");
  }
  return {
    statusCode: 301,
    statusDescription: "Moved Permanently",
    headers: {
      location: { value: newUrl }
    }
  };
}
