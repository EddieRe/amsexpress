(function () {
  var aEls = document.getElementsByTagName('a');
  var pdfs = [];

  for (var i = 0; i < aEls.length; i++) {
    var aEl = aEls[i];
    var suffix = aEl.innerText.slice(aEl.innerText.length - 4);
    if (suffix === '.pdf') {
      pdfs.push([aEl.innerText, aEl.href]);
    }
  }

  return JSON.stringify(pdfs);
})();