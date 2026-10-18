Feature: GET /usuarios - Listar usuarios

  Background:
    * url baseUrl
    * def usuarioSchema = read('classpath:serverest/common/schemas/usuario.json')
    * def listaSchema = read('classpath:serverest/common/schemas/lista-usuarios.json')

  Scenario: Listar todos los usuarios
    Given path 'usuarios'
    When method get
    Then status 200
    And match response == listaSchema
    And match each response.usuarios == usuarioSchema
    And match response.quantidade == response.usuarios.length

  Scenario: Buscar usuarios filtrando por email
    * def nuevo = call read('classpath:serverest/common/helpers/crear-usuario.feature')

    Given path 'usuarios'
    And param email = nuevo.usuario.email
    When method get
    Then status 200
    And match response.quantidade == 1
    And match response.usuarios[0].email == nuevo.usuario.email
    And match response.usuarios[0]._id == nuevo.id

    * call read('classpath:serverest/common/helpers/eliminar-usuario.feature') { id: '#(nuevo.id)' }

  Scenario: Filtrar por un email que no existe devuelve una lista vacia
    Given path 'usuarios'
    And param email = 'noexiste123456@test.com'
    When method get
    Then status 200
    And match response == { quantidade: 0, usuarios: [] }

  Scenario: Filtrar con un valor invalido de administrador
    Given path 'usuarios'
    And param administrador = 'si'
    When method get
    Then status 400
    And match response.administrador == "administrador deve ser 'true' ou 'false'"
