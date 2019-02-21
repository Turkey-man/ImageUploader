# ImageUploader
Application populates Collection View with images from device gallery. CollectionView has 3 cells in a row in portrait and 5 in landscape orientation. Uploading images to Imgur via Alamofire post and upload requests by tapping the Collection View Cell, causing it to highlight and have animated Activity Indicator. Highlight and Activity Indicator remain visible even after scrolling and disappear after the image is uploaded. Tapping the cell without the Internet connection calls up the Alert Controller. Received links are stored in CoreData and displayed in Table View: tap on the cell opens the link in a native browser. Links also can be deleted, one by one or all at once.

![imageuploadergif](https://user-images.githubusercontent.com/18172342/53198014-1628b580-3624-11e9-910e-55fc77d45789.gif)

