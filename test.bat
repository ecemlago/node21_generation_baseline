call .\build.bat

docker volume create nodulegeneration-output

docker run --rm^
 --memory=8g^
 -v %~dp0\test\:/input/^
 -v nodulegeneration-output:/output/^
 nodulegeneration

docker run --rm^
 -v nodulegeneration-output:/output/^
 python:3.7-slim cat /output/results.json | python -m json.tool

docker run --rm^
 -v nodulegeneration-output:/output/^
 -v %~dp0\test\:/input/^
 python:3.7-slim python -c "import json, sys; f1 = json.load(open('/output/results.json')); f2 = json.load(open('/input/expected_output.json')); sys.exit(f1 != f2);"

if %ERRORLEVEL% == 0 (
	echo "Tests successfully passed..."
)
else
(
	echo "Expected output was not found..."
)

docker volume rm nodulegeneration-output
