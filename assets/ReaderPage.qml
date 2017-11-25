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
