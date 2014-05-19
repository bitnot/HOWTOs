Quick start SonarQube on Win-x86 machine with MS SQL Server Express (for ASP.NET project)
=========================================================================================

**DISCLAIMER:** I am not responsible for anything. Read the script before running it. Use it on your own risk.

1. Installation
--------------------------------------------------

Run _init.bat_. 
This will create following important files and folders:
```
.
|--download
|
|--jb-commandline
|	|--inspectcode.exe
|
|--sonar-runner-2.4
|	|--bin
|	|	|--sonar-runner.bat
|	|--conf
|		|--sonar-runner.properties
|
|--sonarqube-4.3
	|--bin
	|	|--windows-x86-32
	|		|--StartSonar.bat
	|--conf
	|	|--sonar.properties
	|--extensions
	 	|--jdbc-driver
	 	|	|--mssql
	 	|		|--sqljdbc4.jar
	 	|--plugins
	 		|--sonar-csharp-plugin-3.0.jar
	 		|--sonar-javascript-plugin-1.6.jar
	 		|--sonar-resharper-plugin-1.0.jar
	 		|--sonar-stylecop-plugin-1.0.jar
	 		|--sonar-visual-studio-plugin-1.0.jar
	 		|--sonar-web-plugin-2.2.jar
	 		|--sonar-xml-plugin-1.1.jar

```


2. Database configuration 
--------------------------------------------------

### Create Sonar database on your MS SQL Server
```
USE master;
GO
CREATE DATABASE sonar;
GO
```

### Add user sonar/sonar and grant permissions
```
CREATE LOGIN sonar 
    WITH PASSWORD = 'sonar';	
USE sonar;
GO
CREATE USER sonar FOR LOGIN sonar 
    WITH DEFAULT_SCHEMA = dbo;	
GO
EXEC sp_addrolemember 'db_owner', 'sonar';
GO
```
Make sure to change default login and password

### Edit _sonarqube-4.3/conf/sonar.properties_

Comment out H2 related lines:
```
#sonar.jdbc.url=jdbc:h2:tcp://localhost:9092/sonar
```

Change "Microsoft SQLServer" section and modify [connection string](http://technet.microsoft.com/en-us/library/ms378428.aspx):
```
sonar.jdbc.url: jdbc:sqlserver://localhost;databaseName=sonar;instanceName=SQLEXPRESS;selectMethod=cursor;
sonar.jdbc.driverClassName: com.microsoft.sqlserver.jdbc.SQLServerDriver
sonar.jdbc.validationQuery: select 1
sonar.jdbc.dialect= mssql
```

### Edit _sonar-runner-2.4/conf/sonar-runner.properties_

Change "Microsoft SQLServer" section and modify [connection string](http://technet.microsoft.com/en-us/library/ms378428.aspx):
```
sonar.jdbc.url: jdbc:sqlserver://localhost;databaseName=sonar;instanceName=SQLEXPRESS;selectMethod=cursor;
sonar.jdbc.driverClassName: com.microsoft.sqlserver.jdbc.SQLServerDriver
sonar.jdbc.validationQuery: select 1
sonar.jdbc.dialect= mssql
```
Change "Global database settings" section
```
sonar.jdbc.username=sonar
sonar.jdbc.password=sonar
```
	
	
3. Sonar configuration
--------------------------------------------------

Open cmd and navigate to current directory

Run `_sonar-runner-2.4/bin/windows-x86-32/StartSonar.bat -X`

Examine errors (if there's any) and deal with them

Open [http://localhost:9000](http://localhost:9000)

Log in as admin/admin

Change default password

Configure paths for external tools

**TODO...**


4. Project Configuration
--------------------------------------------------

Add _sonar-project.properties_ one level up the _.sln_ file

```
sonar.projectKey=org.company.projectname
sonar.projectName=Project Name
sonar.projectVersion=1.0
sonar.sourceEncoding=UTF-8

# Enable the Visual Studio bootstrapper
sonar.visualstudio.enable=true

# This property is set because it is required by the SonarQube Runner.
# But it is not taken into account because the location of the source
# code is retrieved from the .sln and .csproj files.
# Do not set it to "." as it may result in unexpected behaviour 
sonar.sources=src
sonar.exclusions=src/packages/**, **/_ReSharper.**, **/bin/**, **/obj/**
```