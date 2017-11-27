import bb.cascades 1.4
import bb.system 1.2

Page {
    property bool isLoading: false
    
    onCreationCompleted: {
        _reader.htmlReady.connect(onHtmlReady)
        _reader.error.connect(onError)
    }
    
    function read(url) {
        isLoading = true
        _reader.read(url)
        
        /*
         * 
         * Alternate method using Javascript below.
         * 
         * I personally don't like this method as you expose your API key inside a
         * QML file, which is easily accessible if someone can get a hand on your
         * .bar file. If you use this method, better make a Q_INVOKABLE method in
         * your ApplicationUI.cpp/hpp to get your API key from there instead.
         * 
         * 
        var xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function() {
            if(xhttp.readyState === XMLHttpRequest.DONE) {
                if (xhttp.status === 200) {
                    var content = JSON.parse(xhttp.responseText).content
                    webView.html = "<html>" + content + "</html>"
                    isLoading = false;
                }
            }
        };
        
        var getUrl = "https://mercury.postlight.com/parser?url=" + url
        
        xhttp.open("GET", getUrl, true);
        xhttp.setRequestHeader("Content-Type", "application/json")
        xhttp.setRequestHeader("x-api-key", "YOUR_API_KEY")
        xhttp.send();
        */
    }

    function onHtmlReady(html) {
        webView.html = html
        isLoading = false;
    }
    
    function onError(message) {
        webView.html = "<html>" + message + "</html>"
        isLoading = false;
    }
    
    Container {
        layout: DockLayout {}
        horizontalAlignment: HorizontalAlignment.Fill
        verticalAlignment: VerticalAlignment.Fill
        attachedObjects: [ LayoutUpdateHandler { id: mainContainerLuh } ]
        ScrollView {
            scrollViewProperties {
                scrollMode: ScrollMode.Vertical 
                overScrollEffectMode: OverScrollEffectMode.None
            }
            scrollRole: ScrollRole.Main
            WebView {
                id: webView
                minHeight: mainContainerLuh.layoutFrame.height
                minWidth: mainContainerLuh.layoutFrame.width
            }
        }
        
        ActivityIndicator { 
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            minWidth: ui.du(10)
            minHeight: minWidth
            running: isLoading
            visible: running
        }
    }
}
