for /f "delims=" %%a in ("C:\Users\TBSInternet\Documents\Git\bin\Git.exe") do set gitapp=%%~a
pushd "C:\Users\TBSInternet\Documents\GitHub\skeletonkey"
"%gitapp%" add .
"%gitapp%" commit -m %1%
"%gitapp%" push --repo http://romjacket:setEnv88@github.com/romjacket/skeletonKey
