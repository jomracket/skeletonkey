for /f "delims=" %%a in ("E:\Program Files\git\bin\git.exe") do set gitapp=%%~a
pushd "C:\Users\TBSInternet\Documents\GitHub\skeletonKey"
"%gitapp%" add .
"%gitapp%" commit -m %1%
"%gitapp%" push origin master
