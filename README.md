# Reto Automatización QA - BackEnd (ServeRest)

Pruebas automatizadas de la API de Usuarios de [ServeRest](https://serverest.dev/) usando Karate DSL.

## Requisitos

- Java 21 (OpenJDK, por ejemplo [Eclipse Temurin](https://adoptium.net/))
- Maven 3.9 o superior
- Conexión a internet (las pruebas se ejecutan contra https://serverest.dev)

## Configuración

1. Instalar Java 21 y Maven.

2. Configurar la variable de entorno `JAVA_HOME` apuntando a la carpeta del JDK 21 y agregar `%JAVA_HOME%\bin` al `PATH`.

   Ejemplo en Windows (PowerShell):

   ```powershell
   setx JAVA_HOME "C:\Program Files\Eclipse Adoptium\jdk-21.0.12.101-hotspot"
   ```

   Después de ejecutarlo hay que abrir una nueva terminal.

3. Verificar que Maven esté usando Java 21:

   ```bash
   java -version
   mvn -v
   ```

   En la salida de `mvn -v` debe aparecer `Java version: 21...`.

4. Clonar el repositorio:

   ```bash
   git clone <url-del-repositorio>
   cd <carpeta-del-proyecto>
   ```

5. (Opcional) Descargar las dependencias antes de ejecutar:

   ```bash
   mvn dependency:resolve
   ```

La URL de la API se configura en `src/test/java/karate-config.js`. Si se quiere apuntar a otro ambiente, solo hay que cambiar el valor de `baseUrl`.

## Ejecución

### Todas las pruebas

```bash
mvn test
```

### Un feature

Cada feature tiene su propio método en la clase `UsuariosTest`:

| Feature | Método |
|---|---|
| listar-usuarios.feature | `listarUsuarios` |
| registrar-usuario.feature | `registrarUsuario` |
| buscar-usuario.feature | `buscarUsuario` |
| actualizar-usuario.feature | `actualizarUsuario` |
| eliminar-usuario.feature | `eliminarUsuario` |

```bash
mvn test "-Dtest=UsuariosTest#registrarUsuario"
```

### Un escenario

Agregar un tag encima del escenario, por ejemplo `@probar`:

```gherkin
  @probar
  Scenario: Buscar un ID que no existe
```

Y ejecutar:

```bash
mvn test "-Dkarate.options=--tags @probar"
```

También se puede indicar el archivo y la línea donde empieza el escenario:

```bash
mvn test "-Dkarate.options=classpath:serverest/usuarios/buscar-usuario.feature:20"
```

> En PowerShell hay que dejar las comillas en los parámetros `-D`.

### Desde el IDE

Abrir `src/test/java/serverest/UsuariosTest.java` y usar el botón ▶:

- Junto a la clase: ejecuta todas las pruebas.
- Junto a un método: ejecuta solo ese feature.

En VS Code se necesita la extensión **Extension Pack for Java**.

## Reporte

Al terminar la ejecución se genera el reporte HTML de Karate en:

```
target/karate-reports/karate-summary.html
```

## Estructura del proyecto

```
src/test/java
├── karate-config.js                 -> configuración (baseUrl)
└── serverest
    ├── UsuariosTest.java            -> runner
    ├── usuarios                     -> un feature por endpoint
    │   ├── listar-usuarios.feature      GET    /usuarios
    │   ├── registrar-usuario.feature    POST   /usuarios
    │   ├── buscar-usuario.feature       GET    /usuarios/{_id}
    │   ├── actualizar-usuario.feature   PUT    /usuarios/{_id}
    │   └── eliminar-usuario.feature     DELETE /usuarios/{_id}
    └── common
        ├── helpers                  -> features reutilizables (crear y eliminar usuario)
        ├── schemas                  -> esquemas JSON para validar las respuestas
        └── utils
            └── data-generator.js    -> genera datos de usuario aleatorios
```

## Casos de prueba

| Endpoint | Casos positivos | Casos negativos |
|---|---|---|
| GET /usuarios | Listar todos, filtrar por email, filtro sin resultados | Filtro con valor inválido |
| POST /usuarios | Registrar usuario administrador y no administrador | Email repetido, campos obligatorios, email inválido, administrador inválido |
| GET /usuarios/{_id} | Buscar usuario existente | ID que no existe, ID con formato inválido |
| PUT /usuarios/{_id} | Actualizar usuario, ID inexistente crea un usuario | Email de otro usuario, sin nombre |
| DELETE /usuarios/{_id} | Eliminar usuario existente | ID que no existe |

En total son 22 escenarios.

El informe con la estrategia de automatización está en [INFORME.txt](INFORME.txt).
