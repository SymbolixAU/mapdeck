function makeAlert(text) {
    console.log(text);
}

if (typeof mergeInto !== 'undefined') mergeInto(LibraryManager.library, {
    my_js: function() {
        makeAlert("Hello world");
    }
});
