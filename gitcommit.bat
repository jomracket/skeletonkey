for /f "delims=" %%a in ("") do set gitapp=%%~a
cd "C:\Users\TBSInternet\Documents\GitHub\skeletonKey"
"%gitapp%" add .
"%gitapp%" commit -m %1%.
"%gitapp%" push origin master
