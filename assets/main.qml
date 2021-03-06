/*
 * Copyright (c) 2011-2015 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.4
import bb.system 1.2

NavigationPane {
    Page {
        shortcuts: [
            SystemShortcut {
                type: SystemShortcuts.PreviousSection
                onTriggered: {
                    if (webView.canGoBack)
                        webView.goBack()
                }
            },
            SystemShortcut {
                type: SystemShortcuts.NextSection
                onTriggered: {
                    if (webView.canGoForward)
                        webView.goForward()
                }
            }
        ]
        
        actions: [
            ActionItem {
                title: qsTr("Reader Mode") + Retranslate.onLanguageChanged
                ActionBar.placement: ActionBarPlacement.Signature
                imageSource: "asset:///Images/reader.png"
                enabled: webView.isUrlValid(webView.url.toString())
                onTriggered: { 
                    var createdControl = readerPage.createObject()
                    push(createdControl)
                    createdControl.read(webView.url.toString())
                }
                attachedObjects: [
                    ComponentDefinition {
                        id: readerPage 
                        ReaderPage {}
                    }
                ]
            },
            ActionItem {
                title: qsTr("Clear cache") + Retranslate.onLanguageChanged
                ActionBar.placement: ActionBarPlacement.OnBar
                imageSource: "asset:///Images/delete.png"
                onTriggered: { 
                    webView.storage.clearCache()
                    clearCacheDialog.show()
                }
                attachedObjects: [
                    SystemDialog {
                        id: clearCacheDialog
                        title: qsTr("Cache cleared") + Retranslate.onLocaleOrLanguageChanged
                        body: qsTr("Cache was cleared successfully!") + Retranslate.onLocaleOrLanguageChanged
                        cancelButton.label: ""
                    }
                ]
            }
        ]
        
        Container {
            layout: DockLayout {}
            horizontalAlignment: HorizontalAlignment.Fill
            verticalAlignment: VerticalAlignment.Fill
            attachedObjects: [ LayoutUpdateHandler { id: mainContainerLuh } ]
            
            Container {
                Container {
                    layout: StackLayout { orientation: LayoutOrientation.LeftToRight }
                    attachedObjects: [ LayoutUpdateHandler { id: navigationBarLuh } ]
                    Button {
                        text: "<"
                        maxWidth: ui.du(10)
                        verticalAlignment: VerticalAlignment.Center
                        enabled: webView.canGoBack
                        onClicked: webView.goBack()
                    }
                    Button {
                        text: ">"
                        maxWidth: ui.du(10)
                        verticalAlignment: VerticalAlignment.Center
                        enabled: webView.canGoForward
                        onClicked: webView.goForward()
                    }
                    TextField {
                        id: urlBar
                        inputMode: TextFieldInputMode.Url
                        verticalAlignment: VerticalAlignment.Center
                        input.submitKey: SubmitKey.EnterKey
                        input.onSubmitted: { 
                            webView.url = webView.isUrlValid(text) ?
                                text :
                                ("https://www.google.ca/search?q=" + text)
                        }
                    }
                }
                
                ScrollView {
                    scrollViewProperties {
                        scrollMode: ScrollMode.Vertical 
                        overScrollEffectMode: OverScrollEffectMode.None
                    }
                    scrollRole: ScrollRole.Main
                    WebView {
                        id: webView
                        
                        function isUrlValid(url) {
                            return url.toString().indexOf("http") == 0
                        }
                        
                        function isLocalUrl(url) {
                            return url.toString().indexOf("local://") == 0
                        }
                        
                        url: "http://www.crackberry.com"
                        minHeight: mainContainerLuh.layoutFrame.height - navigationBarLuh.layoutFrame.height
                        minWidth: mainContainerLuh.layoutFrame.width - navigationBarLuh.layoutFrame.width
                                                
                        onNavigationRequested: {
                            if (request.url != undefined && isLocalUrl(request.url)) {
                                request.action = WebNavigationRequestAction.Ignore
                                localUrlDialog.show()
                            }
                            else {
                                request.action = WebNavigationRequestAction.Accept
                            }
                        }
                        
                        onUrlChanged: {
                            urlBar.text = url.toString()
                        }

                        attachedObjects: [
                            SystemDialog {
                                id: localUrlDialog
                                cancelButton.label: ""
                                title: qsTr("Invalid URL") + Retranslate.onLocaleOrLanguageChanged
                                body: qsTr("Please enter a valid URL.") + Retranslate.onLocaleOrLanguageChanged
                            }
                        ]
                    }
                }
            }
            
            ActivityIndicator { 
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                minWidth: ui.du(10)
                minHeight: minWidth
                running: webView.loading
                visible: running
            }
        }
    }
}
