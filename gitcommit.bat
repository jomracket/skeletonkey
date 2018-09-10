for /f "delims=" %%a in ("E:\Program Files (x86)\Git\bin\git.exe") do set gitapp=%%~a
pushd "C:\Users\libpublc.NETID\Documents\GitHub\skeletonkey"
"%gitapp%" add .
"%gitapp%" commit -m pfft
"%gitapp%" push --repo https://romjacket@gmail.com:setEnv88@github.com/romjacket/skeletonkey
pause