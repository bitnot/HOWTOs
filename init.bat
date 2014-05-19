ECHO OFF

SETLOCAL 
SET PATH=./bin/;%PATH%

:download
IF EXIST download/sonarqube-4.3.zip ( GOTO unpack )
mkdir download

ECHO Downloading Java x86
curl http://fs31.filehippo.com/9738/c7bb4e5046884266a71d4b772d5b745f/jre-8u5-windows-i586.exe -o download/jre-8u5-windows-i586.exe

ECHO Downloading Sonar
curl http://dist.sonar.codehaus.org/sonarqube-4.3.zip -o download/sonarqube-4.3.zip

ECHO Downloading Runner
curl http://repo1.maven.org/maven2/org/codehaus/sonar/runner/sonar-runner-dist/2.4/sonar-runner-dist-2.4.zip -o download/sonar-runner-dist-2.4.zip

ECHO Downloading plugins
curl http://repository.codehaus.org/org/codehaus/sonar-plugins/visualstudio/sonar-visual-studio-plugin/1.0/sonar-visual-studio-plugin-1.0.jar -o download/sonar-visual-studio-plugin-1.0.jar
curl http://repository.codehaus.org/org/codehaus/sonar-plugins/dotnet/csharp/sonar-csharp-plugin/3.0/sonar-csharp-plugin-3.0.jar -o download/sonar-csharp-plugin-3.0.jar
curl http://repository.codehaus.org/org/codehaus/sonar-plugins/javascript/sonar-javascript-plugin/1.6/sonar-javascript-plugin-1.6.jar -o download/sonar-javascript-plugin-1.6.jar
curl http://repository.codehaus.org/org/codehaus/sonar-plugins/xml/sonar-xml-plugin/1.1/sonar-xml-plugin-1.1.jar -o download/sonar-xml-plugin-1.1.jar
curl http://repository.codehaus.org/org/codehaus/sonar-plugins/sonar-web-plugin/2.2/sonar-web-plugin-2.2.jar -o download/sonar-web-plugin-2.2.jar
curl http://repository.codehaus.org/org/codehaus/sonar-plugins/resharper/sonar-resharper-plugin/1.0/sonar-resharper-plugin-1.0.jar -o download/sonar-resharper-plugin-1.0.jar
curl http://repository.codehaus.org/org/codehaus/sonar-plugins/stylecop/sonar-stylecop-plugin/1.0/sonar-stylecop-plugin-1.0.jar -o download/sonar-stylecop-plugin-1.0.jar

ECHO Downloading MS SQL Server JDBC driver
curl http://download.microsoft.com/download/D/6/A/D6A241AC-433E-4CD2-A1CE-50177E8428F0/1033/sqljdbc_3.0.1301.101_enu.tar.gz -o download/sqljdbc_3.0.1301.101_enu.tar.gz

ECHO Downloading External tools
curl http://download-cf.jetbrains.com/resharper/jb-commandline-8.2.0.2151.zip -o download/jb-commandline.zip
curl http://dl.dropboxusercontent.com/u/1311259/FxCopSetup-10.0.exe -o download/FxCopSetup-10.0.exe 

:unpack
ECHO Extracting files
IF EXIST sonarqube-4.3/COPYING ( GOTO tools )
unzip -o -q download/sonarqube-4.3.zip -d ./
unzip -o -q download/sonar-runner-dist-2.4.zip -d ./
unzip -o -q download/jb-commandline.zip -d ./jb-commandline
zcat ./download/sqljdbc_3.0.1301.101_enu.tar.gz  | tar xf -

:copyplugins
copy download\*.jar .\sonarqube-4.3\extensions\plugins /Y

:copydriver
ren .\sonarqube-4.3\extensions\jdbc-driver\mssql\*.jar *.bak
copy sqljdbc_3.0\enu\sqljdbc4.jar .\sonarqube-4.3\extensions\jdbc-driver\mssql /Y

:tools 
ECHO Installing files
start download\jre-8u5-windows-i586.exe
start download\FxCopSetup-10.0.exe

:cleanup
ECHO Cleaning up
rmdir sqljdbc_3.0 /R /Q
rem rmdir download /R /Q

:end
PAUSE