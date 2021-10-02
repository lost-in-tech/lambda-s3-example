dotnet test --collect:"XPlat Code Coverage" --results-directory "TestReports\Tests"
dotnet tool install -g dotnet-reportgenerator-globaltool
reportgenerator -targetdir:"TestReports\Coverage" -reports:"TestReports\Tests\*\*.xml" -reporttypes:Html
start TestReports\Coverage\Index.htm