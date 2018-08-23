for /f "delims=" %%a in ("E:\Program Files\git\bin\git.exe") do set gitapp=%%a
cd "C:\Users\TBSInternet\Documents\GitHub\skeletonkey"
"%gitapp%" add .
"%gitapp%" commit -m %1%
"%gitapp%" push origin master
