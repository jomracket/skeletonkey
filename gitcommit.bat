for /f "delims=" %%a in ("E:\Program Files (x86)\Git\bin\git.exe") do set gitapp=%%~a
pushd "C:\Users\libpublc.NETID\Documents\GitHub\skeletonkey"
"%gitapp%" add .
"%gitapp%" commit -m %1%
"%gitapp%" push origin master
pause