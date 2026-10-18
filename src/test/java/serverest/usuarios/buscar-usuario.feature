Feature: GET /usuarios/{_id} - Buscar usuario por ID

  Background:
    * url baseUrl
    * def usuarioSchema = read('classpath:serverest/common/schemas/usuario.json')

  Scenario: Buscar un usuario existente por su ID
    * def nuevo = call read('classpath:serverest/common/helpers/crear-usuario.feature')

    Given path 'usuarios', nuevo.id
    When method get
    Then status 200
    And match response == usuarioSchema
    And match response.nome == nuevo.usuario.nome
    And match response.email == nuevo.usuario.email
    And match response._id == nuevo.id

    * call read('classpath:serverest/common/helpers/eliminar-usuario.feature') { id: '#(nuevo.id)' }

  Scenario: Buscar un ID que no existe
    Given path 'usuarios', 'idNoExiste123456'
    When method get
    Then status 400
    And match response.message == 'Usuário não encontrado'

  Scenario: Buscar con un ID de formato invalido
    Given path 'usuarios', '123'
    When method get
    Then status 400
    And match response.id == 'id deve ter exatamente 16 caracteres alfanuméricos'
