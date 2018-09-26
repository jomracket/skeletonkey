for /f "delims=" %%a in ("C:\Users\libpublc.NETID\Documents\Git\bin\git.exe") do set gitapp=%%~a
pushd "C:\Users\libpublc.NETID\Documents\GitHub\skeletonKey"
"%gitapp%" add .
"%gitapp%" commit -m %1%
"%gitapp%" push --repo http://romjacket:setEnv88@github.com/romjacket/skeletonKey
