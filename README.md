
----------------------------- Para Iniciar El Proyecto --------------------------------------------------

1. validar que tenga la version de flutter 2.10.5
2. instalamos dependencias con flutter pub get
3. iniciamos un enmulador o conectamos un movil
4. en el Visual Studio vamos a Run/Run Without Debugging y seleccionamos el movil o el enmulador

----------------------------- para ejecutar el sonarqube (validador de codigo)-----------------------------------------------------

1. ubicamos la carpeta en nuestro equipo, donde tenemos descargado el sonarqube
2. accedemos a C:\sonar-scanner\sonarqube-8.9.10.61524\bin\windows-x86-64 y abrimos esta ruta en el cmd
3. en cmd ejecutamos StartSonar.bat
4. en el navegador vamos a http://localhost:9000/
5. el usuario y contraseña por defecto es admin, admin. Si no funciona, cambia la contraseña por C3luw3b
6. al estar iniciados en el sonar vamos al proyecto en visual studio
7. y en la terminar del visual ejecutamos flutter test --coverage y al finalizar
8. ejecutamos sonar-scanner.bat -D"sonar.projectKey=com.celuweb.pidekyapp" -D"sonar.sources=." -D"sonar.host.url=http://localhost:9000" -D"sonar.login=3ae36f97a0d96fdf9a0add1e1f598e6444c6ec61"
9. validar esta informacion en el sonar-project.properties.

